# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use Pty qw(:ALL);
use IO::File;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my ($fdm) = IO::File->new("/dev/ptmx", "r+") || die("not ok 2: $!\n");
print("ok 2\n");
grantpt($fdm) == 0 || die("not ok 3: $!\n");
print("ok 3\n");
unlockpt($fdm) == 0 || die("not ok 4: $!\n");
print("ok 4\n");
my ($slavename) = ptsname($fdm) || die("not ok 5: $!\n");
print("ok 5\n");
my ($fds) = IO::File->new($slavename, "r") || die("not ok 6: $!\n");
print("ok 6\n");
my $tmp;
ioctl($fds, I_PUSH, $tmp = "ptem") || die("not ok 7: $!\n");
print("ok 7\n");
ioctl($fds, I_PUSH, $tmp = "ldterm") || die("not ok 8: $!\n");
print("ok 8\n");

##########################
