Include './example.sh'
Describe 'hello.sh'
  It 'says hello'
    When call hello ShellSpec
    The output should equal 'Hello ShellSpec!'
  End
End
