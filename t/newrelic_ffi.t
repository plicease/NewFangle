use Test2::V0 -no_srand => 1;
use NewRelic::FFI;

imported_ok('$ffi');
isa_ok $ffi, 'FFI::Platypus';

done_testing;
