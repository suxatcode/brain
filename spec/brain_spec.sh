Include './brain_functions.sh'

Describe 'brain_functions.sh: find_file'
  setup() {
    mkdir -p ./testdata/
    touch ./testdata/a.lang
    touch ./testdata/borc.lang
    touch ./testdata/Xborc.lang
    touch ./testdata/cord.lang
  }
  cleanup() {
    rm -r ./testdata;
  }
  BeforeCall 'setup'
  AfterCall 'cleanup'

  It 'finds exact match "a.lang"'
    When call __brain_find_file_in_path './testdata' 'a'
    The output should equal './testdata/a.lang'
  End
  # must merge main first
  #It 'finds incomplete match, but not prefix "borc.lang"'
  #  When call __brain_find_file_in_path './testdata' 'bo'
  #  The output should equal './testdata/borc.lang'
  #End
  It 'finds incomplete match "cord.lang"'
    When call __brain_find_file_in_path './testdata' 'cor'
    The output should equal './testdata/cord.lang'
  End
End
