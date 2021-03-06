      subroutine genfmt (ipr3, critcw, sig2g)
      implicit double precision (a-h, o-z)

      include 'const.h'
      include 'dim.h'
      include 'pdata.h'
      include 'vers.h'
      include 'pola.h'

      double precision xnlm(ltot+1, mtot+1)
      double precision dri(ltot+1, 2*mtot+1, 2*mtot+1, legtot+1)
      complex*16 clmi(ltot+1, mtot+ntot+1, legtot)
      complex*16 fmati(lamtot, lamtot, legtot)

      complex*16 rho(legtot), pmati(lamtot,lamtot,2)
      complex*16 pllp, ptrac, srho, prho, cdel1, cfac
      complex*16 cchi(nex), cfms, mmati
      complex*16 ck(nex)
      integer mlam(lamtot), nlam(lamtot)

      dimension  mmati(-mtot:mtot,-mtot:mtot)
      dimension  t3j(-mtot-1:mtot+1,-1:1)
      double precision  xk(nex)
      character*128 fname, messag

      logical done

c     Input flags:
c     iorder, order of approx in f-matrix expansion (see setlam)
c             (normal use, 2.  Do ss exactly regardless of iorder)

c     used for divide-by-zero and trig tests
      parameter (eps = 1.0e-16)

c  Read phase calculation
      fname = 'phase.bin'
      call rphbin(fname, ntext, ntitle, text, title, npot, potlbl,
     $     nsc, ne, ik0, ihole, l0, il0, lmaxp1, ltext, ltitle, iz,
     $     lmax, rnrmav, xmu, edge, em, eref, ph)
c
c  Set nlm factors for use later
      call snlm(ltot, mtot, xnlm)
      if (pola) then
c  Make 3j factors in t3j  (multiplied by sqrt(3*(2l0+1)) for
c  further convinience - the same expression for chi)
c  l0 - final momentum, initial momentum = l0-1.
         do 140  m0 = -l0+1,l0-1
            t3j(m0, 1) = (-1)**(l0+1+m0)*sqrt(3.0d0*(l0+m0)*(l0+m0+1)
     1                /(2*l0)/(2*l0-1))
            t3j(m0, 0) = (-1)**(l0+m0)*sqrt(3.0d0*(l0*l0-m0*m0)/
     1                l0/(2*l0-1))
  140    continue
         do 145  m0 = -l0+1,l0-1
            t3j(m0,-1) = t3j(-m0,1)
  145    continue
      endif


c     Open path input file (unit in) and read title.  Use unit 1.
      ntitle = 5
      open (unit=1, file='paths.dat', status='old', iostat=ios)
      call chopen (ios, 'paths.dat', 'genfmt')
      call rdhead (1, ntitle, title, ltitle)
      if (ntitle .le. 0)  then
         title(1) = ' '
         ltitle(1) = 1
      endif

c     cgam = gamma in mean free path calc (eV).  Set to zero in this
c     version.  Set it to whatever you want if you need it.
c     cgam = 0
c     cgam = cgam / ryd
c     add cnst imag part to eref
c     do 20  ie = 1, ne
c        eref(ie) = eref(ie) - coni*cgam/2
c  20 continue

   50 format (a)
   60 format (1x, a)
   70 format (1x, 79('-'))

c     Save filenames of feff.dat files for use by ff2chi
      open (unit=2, file='files.dat', status='unknown', iostat=ios)
      call chopen (ios, 'files.dat', 'genfmt')
c     Put phase header on top of files.dat
      do 100  itext = 1, ntext
         write(2,60)  text(itext)(1:ltext(itext))
  100 continue
      write(2,70)
      write(2,120)
  120 format ('    file        sig2   amp ratio    ',
     1        'deg    nlegs  r effective')

c     Set crit0 for keeping feff.dat's
      if (ipr3 .le. 0)  crit0 = 2*critcw/3
c     Make a header for the running messages.
       write(messag, 130) critcw
       call echo(messag)
  130 format ('    Curved wave chi amplitude ratio', f7.2, '%')
      if (ipr3 .le. 0)  then
         write(messag, 131) crit0
         call echo(messag)
       endif
  131 format ('    Discard feff.dat for paths with cw ratio <',
     1         f7.2, '%')
       write(messag, 132)
       call echo(messag)
  132 format ('    path  cw ratio     deg    nleg  reff')


c     While not done, read path, find feff.
      npath = 0
      ntotal = 0
      nused = 0
      xportx = -1
c
c start of "for each path" loop
  200 continue
c     Read current path
          in = 1
          call read_pathgeom(in, ipath, nleg, npot, deg,
     $         rat, ipot, potlbl, done)

          if (done) goto 1000
          nsc = nleg - 1
          call calc_pathgeom(nleg, rat, ipot, ri, beta, eta)

         npath = npath + 1
         ntotal = ntotal + 1

c        Need reff
         reff = 0
         do 220  i = 1, nleg
            reff = reff + ri(i)
  220    continue
         reff = reff/2

c        Set lambda for low k
         call setlam(nsc, il0, mmaxp1, lamx, laml0x, nmax, mlam, nlam)

c        Calculate and store rotation matrix elements
c        Only need to go to (il0, il0, ...) for isc=nleg and
c        nleg+1 (these are the paths that involve the 'z' atom
         call rot3i (il0, il0, nleg, beta(nleg), dri)
         do 400  isc = 1, nsc
            call rot3i (lmaxp1, mmaxp1, isc, beta(isc), dri)
  400    continue
         if (pola) then
c           one more rotation in polarization case
            call rot3i (il0, il0, nleg+1, beta(nleg+1), dri)
            call mmtr(t3j, mmati, nsc, nleg, l0, il0, dri, eta)
         endif

c        Big energy loop
         do 800  ie = 1, ne

c           real momentum (k)
            xk(ie) = getxk(em(ie) - edge)

c           complex momentum (p)
            ck(ie) = sqrt (em(ie) - eref(ie))
c           complex rho
            do 420  ileg = 1, nleg
               rho(ileg) = ck(ie) * ri(ileg)
  420       continue

c           if ck is zero, xafs is undefined.  Make it zero and jump
c           to end of calc part of loop.
            if (abs(ck(ie)) .le. eps)  then
               cchi(ie) = 0
               goto 620
            endif

c           Calculate and store spherical wave factors c_l^(m)z^m/m!
c           in a matrix clmi(il,im,ileg), ileg=1...nleg.
c           Result is that common /clmz/ is updated for use by fmtrxi.

c           zero clmi arrays
            do 440  ileg = 1, legtot
            do 440  il = 1, ltot+1
            do 440  im = 1, mtot+ntot+1
               clmi(il,im,ileg) = 0
  440       continue

            mnmxp1 = mmaxp1 + nmax

            lxp1 = max (lmax(ie,ipot(1))+1, l0+1)
            mnp1 = min (lxp1, mnmxp1)
            call sclmz (rho, lxp1, mnp1, 1, clmi)

            lxp1 = max (lmax(ie,ipot(nsc))+1, l0+1)
            mnp1 = min (lxp1, mnmxp1)
            call sclmz (rho, lxp1, mnp1, nleg, clmi)

            do 460  ileg = 2, nleg-1
               isc0 = ileg-1
               isc1 = ileg
               lxp1 = max (lmax(ie,ipot(isc0))+1, lmax(ie,ipot(isc1))+1)
               mnp1 = min (lxp1, mnmxp1)
               call sclmz (rho, lxp1, mnp1, ileg, clmi)
  460       continue

c           Calculate and store scattering matrices fmati.
            if (pola) then
c              Polarization version, make new m matrix
c              this will fill fmati(...,nleg) in common /fmtrxi/
               call mmtrxi (laml0x, mmati, ie, 1, nleg,
     $              mlam, nlam, il0, xnlm, clmi, fmati)
            else
c              Termination matrix, fmati(...,nleg)
               iterm = 1
               call fmtrxi(laml0x, laml0x, ie, iterm, 1, nleg,
     $              mlam, nlam, dri, xnlm, clmi, fmati,
     $              ph, eta, lmax, ipot, il0)
            endif
            iterm = -1
c           First matrix
            call fmtrxi (lamx, laml0x, ie, iterm, 2, 1,
     $           mlam, nlam, dri, xnlm, clmi, fmati,
     $           ph, eta, lmax, ipot, il0)
c           Last matrix if needed
           if (nleg .gt. 2)  then
               call fmtrxi(laml0x, lamx, ie, iterm, nleg, nleg-1,
     $             mlam, nlam, dri, xnlm, clmi, fmati,
     $             ph, eta, lmax, ipot, il0)
            endif
c           Intermediate scattering matrices
            do 480  ilegp = 2, nsc-1
               ileg = ilegp + 1
               call fmtrxi(lamx, lamx, ie, iterm, ileg, ilegp,
     $              mlam, nlam, dri, xnlm, clmi, fmati,
     $              ph, eta, lmax, ipot, il0)
  480       continue
c           Big matrix multiplication loops.
c           Calculates trace of matrix product
c           M(1,N) * f(N,N-1) * ... * f(3,2) * f(2,1), as in reference.
c           We will (equivalently) calculate the trace over lambda_N of
c           f(N,N-1) * ... * f(3,2) * f(2,1) * M(1,N), working from
c           right to left.
c           Use only 2 pmati arrays, alternating indp (index p)
c           1 and 2.

c           f(2,1) * M(1,N) -> pmat(1)
            indp = 1
            do 520  lmp = 1, laml0x
            do 520  lm = 1, lamx
               pllp = 0
               do 500  lmi = 1, laml0x
                  pllp = pllp + fmati(lm,lmi,1) * fmati(lmi,lmp,nleg)
  500          continue
               pmati(lm,lmp,indp)=pllp
  520       continue

c           f(N,N-1) * ... * f(3,2) * [f(2,1) * M(1,N)]
c           Term in [] is pmat(1)
            do 560 isc = 2, nleg-1
c              indp is current p matrix, indp0 is previous p matrix
               indp = 2 - mod(isc,2)
               indp0 = 1 + mod(indp,2)
               do 550  lmp = 1, laml0x
               do 550  lm = 1, lamx
                  pllp=0
                  do 540 lmi = 1, lamx
                     pllp = pllp +
     1                      fmati(lm,lmi,isc)*pmati(lmi,lmp,indp0)
  540             continue
  550          pmati(lm,lmp,indp) = pllp
  560       continue

c           Final trace over matrix
            ptrac=0
            do 580  lm = 1, laml0x
               ptrac = ptrac + pmati(lm,lm,indp)
  580       continue

c           Calculate xafs
c           srho=sum pr(i), prho = prod pr(i)
            srho=0
            prho=1
            do 600  ileg = 1, nleg
               srho = srho + rho(ileg)
               prho = prho * rho(ileg)
  600       continue
c           Complex chi (without 2kr term)
c           ipot(nleg) is central atom
            cdel1 = exp(2*coni*ph(ie,il0,ipot(nleg)))
            cfac = cdel1 * exp(coni*(srho-2*xk(ie)*reff)) / prho

            cchi(ie) = ptrac * cfac/(2*l0+1)

c           When ck(ie)=0, xafs is set to zero.  Calc above undefined.
c           Jump to here from ck(ie)=0 test above.
  620       continue

c        end of energy loop
  800    continue

         call calc_zabinsky(ne, ik0, deg, ck, cchi, xportx, crit)

c        Write output if path is important enough (ie, path has
c               crit>=crit0)
         if (ipr3 .ge. 1  .or.  crit .ge. crit0)  then
            call genfmt_writefeffdat(ipath, ntext, text,
     $           nleg, deg, reff, rnrmav, edge,
     $           rat, iz, ipot, potlbl,
     $           l0, il0, ne, xk, ck, ph, cchi)

c           Put feff.dat and stuff into files.dat
            write(fname, 241)  ipath
 241        format ('feff', i4.4, '.dat')
            il = istrln(fname)
            write(2,820) fname(1:il), sig2g, crit, deg,
     1                   nleg, reff*bohr
  820       format(1x, a, f8.5, 2f10.3, i6, f9.4)

c           Tell user about the path we just did
            write(messag, 210) ipath, crit, deg, nleg, reff*bohr
            call echo(messag)
  210       format (3x, i4, 2f10.3, i6, f9.4)
            nused = nused+1

         else
c           path unimportant, tell user
            write(messag, 211) ipath, crit, deg, nleg, reff*bohr
            call echo(messag)
  211       format (3x, i4, 2f10.3, i6, f9.4, ' neglected')
         endif

c        Do next path
         goto 200

c     Done with loop over paths
 1000 continue
c     close paths.dat, files.dat
      close (unit=1)
      close (unit=2)
      close (unit=4)
       write(messag,1010) nused, ntotal
       call echo(messag)
 1010 format (1x, i4, ' paths kept, ', i4, ' examined.')

      return
      end
