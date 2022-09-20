Describe 'brain_functions.sh:'
  Include './brain_functions.sh' # TODO: should only include find.sh
  setup() {
    mkdir -p ./testdata/{.stversions,ok,all}
    touch ./testdata/a.lang
    touch ./testdata/borc.lang
    touch ./testdata/Xborc.lang
    touch ./testdata/cord.lang
    touch ./testdata/{.stversions/,ok/}def.lang
    touch ./testdata/all/{x,y,z}.lang
  }
  cleanup() {
    rm -r ./testdata;
  }
  BeforeCall 'setup'
  AfterCall 'cleanup'

  Describe '__brain_find_file__fd:'
    It 'finds exact match "a.lang"'
      When call __brain_find_file__fd './testdata' 'a'
      The output should equal './testdata/a.lang'
      The status should be success
    End
    It 'finds incomplete match, but not prefix "borc.lang"'
      When call __brain_find_file__fd './testdata' 'bo'
      The output should equal './testdata/borc.lang'
      The status should be success
    End
    It 'finds incomplete match "cord.lang"'
      When call __brain_find_file__fd './testdata' 'cor'
      The output should equal './testdata/cord.lang'
      The status should be success
    End
    It 'finds "def.lang" and ignores all "__brain_directory_ignores"'
      When call __brain_find_file__fd './testdata' 'def'
      The output should equal './testdata/ok/def.lang'
      The status should be success
    End
  End

  Describe '__brain_find_file__find:'
    It 'finds exact match "a.lang"'
      When call __brain_find_file__find './testdata' 'a'
      The output should equal './testdata/a.lang'
      The status should be success
    End
    It 'finds incomplete match, but not prefix "borc.lang"'
      When call __brain_find_file__find './testdata' 'bo'
      The output should equal './testdata/borc.lang'
      The status should be success
    End
    It 'finds incomplete match "cord.lang"'
      When call __brain_find_file__find './testdata' 'cor'
      The output should equal './testdata/cord.lang'
      The status should be success
    End
    # FIXME: fails, unix find sucks |-(
    #It 'finds "def.lang" and ignores all "__brain_directory_ignores"'
    #  When call __brain_find_file__find './testdata' 'def'
    #  The output should equal './testdata/ok/def.lang'
    #  The status should be success
    #End
  End

  Describe '__brain_find_all:'
    __brain_set_roots "./testdata/all"
    It 'finds all the brain files'
      When call __brain_find_all complete_path
      The output should equal './testdata/all/x.lang
./testdata/all/y.lang
./testdata/all/z.lang'
    End
    It 'finds all the brain files'
      When call __brain_find_all
      The output should equal 'x.lang
y.lang
z.lang'
    End
  End
End
