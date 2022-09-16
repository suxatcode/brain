Include './brain.sh'
Describe 'brain.sh'
  It 'says hello'
    When call testme
    The output should equal 'hello'
  End
End
