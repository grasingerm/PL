function func(i) result(j)
  integer, intent(in) :: i
  integer             :: j
  j = i**2 + i**3
end function func

subroutine hello
  print *, "hello world"
end subroutine
