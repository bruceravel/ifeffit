c     make e and r mesh for phase
c     input:  nr, dx, x0, nemax, iprint,
c             ixanes, edge, xmu, vint, vr0, imt, edens, nph
c             edge, xmu... used only with ixanes = 1
c     output: ri(nr), ne, em(ne), ik0 [grid point with k=0]
c
c     set nemax = nex (from dim.h) for max number of points

      subroutine phmesh (nr, dx, x0, nemax, iprint,
     1                   ixanes, edge, xmu, vint, vr0,
     1                   imt, edens, nph,
     2                   ri, ne, em, ik0)
      implicit double precision (a-h, o-z)
      include 'const.h'
      include 'dim.h'
      double precision rr
      double precision ri(nr), em(nex)
      external rr

c     edens       overlapped density*4*pi
c     imt         r mesh index just inside rmt
c     see arrays.h
      dimension edens(nrptx,0:nphx)
      dimension imt(0:nphx)
      integer i, iscale
c     r mesh
      do 100  i = 1, nr
         ri(i) = rr(i)
  100 continue

c     xkmin needed only with ixanes
      if (ixanes .gt. 0)  then
c        Need xf**2 min for all unique potentials, take rho(imt) as
c        min rho
         xf2int = xmu-vint
         xf2min = xf2int
         do 400  i = 0, nph
            rs = (3 / edens(imt(i),i)) ** third
            xf2 = (fa / rs) ** 2
            if (xf2 .le. xf2min) xf2min = xf2
  400    continue

         xkmin2 = xf2min - vr0
         if (xkmin2 .lt. 0)  then
            call fstop(' at PHMESH: bad vr0')
         endif

         delk = bohr/5
         xkmin = sqrt (xkmin2)
         n = int(xkmin/delk) - 1
      else
         xkmin = 0
         n = 0
      endif

c     energy mesh
c      n pts (-2 le k lt 0,  delk=0.2 ang(-1) ) (only if xanes)
c     30 pts (0 le k le 5.8, delk=0.2 ang(-1) )
c      9 pts (6 le k le 10., delk=0.5 ang(-1) )
c     10 pts (11 le k le 20.0, delk=1.0 ang(-1) )
      ne = 0
      iscale = 1
      delk1 = bohr/(5*iscale)
      delk2 = bohr/(2*iscale)
      delk3 = bohr/iscale

      npts1 = iscale*30
      npts2 = iscale*9
      npts3 = iscale*10

      if (ixanes .gt. 0)  then
         xkmin = n*delk1
         do 110 i=1,n
            ne = ne+1
            em(ne) = edge - (-xkmin+(i-1)*delk1)**2
  110    continue
      endif
c
      do 112 i=1, npts1
         ne = ne+1
         em(ne) = edge + ((i-1)*delk1)**2
         if (i.eq.1)  ik0 = ne
  112 continue
      do 113 i=1, npts2
         ne = ne+1
         em(ne) = edge + (6.d0*bohr + (i-1)*delk2)**2
  113 continue
      do 114 i=1, npts3
         ne = ne+1
         em(ne) = edge + (11.d0*bohr + (i-1)*delk3)**2
  114 continue

c     print*, 'phmesh: ne, nex, nemax before setting ne ',
c    1                 ne, nex, nemax
      ne = min (ne, nemax)
cc      print*, 'phmesh: ne, nex, nemax after  setting ne ',
cc     1                 ne, nex, nemax

      if (iprint .ge. 3)  then
         open (unit=44, file='emesh.dat')
         write(44,*) 'edge, bohr, edge*ryd ', edge, bohr, edge*ryd
         write(44,*) 'ixanes, ik0 ', ixanes, ik0
         write(44,*) vint, xkmin, n, ' vint, xkmin, n'
         write(44,*) 'ie, em(ie), xk(ie)'
         do 230  ie = 1, ne
            write(44,220)  ie, em(ie), getxk(em(ie)-edge)/bohr
  220       format (i5, 2f20.5)
  230    continue
         close (unit=44)
      endif

      return
      end
