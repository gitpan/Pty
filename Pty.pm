package Pty;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

require Exporter;
require DynaLoader;

$VERSION = '0.01';

@ISA = qw(Exporter DynaLoader);
@EXPORT = qw();
@EXPORT_OK = qw(grantpt unlockpt ptsname
                I_ATMARK I_CANPUT I_CKBAND I_EGETSIG I_ESETSIG I_FDINSERT
                I_FIND I_FLUSH I_FLUSHBAND I_GERROPT I_GETBAND I_GETCLTIME
                I_GETSIG I_GRDOPT I_GWROPT I_LINK I_LIST I_LOOK I_NREAD I_PEEK
                I_PLINK I_POP I_PUNLINK I_PUSH I_RECVFD I_SENDFD I_SERROPT
                I_SETCLTIME I_SETSIG I_SRDOPT I_STR I_SWROPT I_UNLINK);

%EXPORT_TAGS = ('ALL' => \@EXPORT_OK);

bootstrap Pty $VERSION;

sub AUTOLOAD
{
my $constname;
($constname = $Pty::AUTOLOAD) =~ s/.*:://;
my ($val) = constant($constname, @_ ? $_[0] : $_);
if ($! != 0)
   {
   if ($! =~ /Invalid/)
      {
      $AutoLoader::AUTOLOAD = $Pty::AUTOLOAD;
      goto &AutoLoader::AUTOLOAD;
      }
   else
      {
      die("Undefined constant $constname");
      }
    }
eval "sub $Pty::AUTOLOAD { $val }";
goto &$Pty::AUTOLOAD;
}

1;

__END__

=head1 NAME

Pty - Perl extension to allow access to the SVR4 pseudo-tty functions

=head1 SYNOPSIS

This module may be used as follows:

   use Pty qw(ALL);
   use IO::File;
   my ($fdm) = IO::File->new("/dev/ptmx", "r+");
   grantpt($fdm);
   unlockpt($fdm);
   my ($slavename) = ptsname($fdm);
   my ($fds) = IO::File->new($slavename, "r");
   my ($mod);
   ioctl($fds, I_PUSH, $mod = "ptem");
   ioctl($fds, I_PUSH, $mod = "ldterm");

=head1 DESCRIPTION

This module allows access to the SVR4 pseudo-tty functions.  grantpt() and
unlockpt() follow the convention used by ioctl() for returning values, i.e. -1
is returned as undef, 0 is returned as the string "0 but true", and any other
value is returned unchanged.  ptsname() returns the pty name if sucessful, and
undef otherwise.

=head2 constants

The following streams-related constants are available:

I_ATMARK I_CANPUT I_CKBAND I_EGETSIG I_ESETSIG I_FDINSERT
I_FIND I_FLUSH I_FLUSHBAND I_GERROPT I_GETBAND I_GETCLTIME
I_GETSIG I_GRDOPT I_GWROPT I_LINK I_LIST I_LOOK I_NREAD I_PEEK
I_PLINK I_POP I_PUNLINK I_PUSH I_RECVFD I_SENDFD I_SERROPT
I_SETCLTIME I_SETSIG I_SRDOPT I_STR I_SWROPT I_UNLINK);

=head2 grantpt()

Changes the mode and ownership of the slave pty associated with the
corresponding master pty.  Parameter is a filehandle.

=head2 unlockpt()

Unlocks the slave pty associated with the corresponding master pty.  Parameter
is a filehandle.

=head2 ptsname()

Returns the name of the slave pty associated with the corresponding master pty.
Parameter is a filehandle.

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Alan Burlison, Alan.Burlison@uk.sun.com

=head1 SEE ALSO

perl(1), grantpt(), unlockpt(), ptsname() and your O/S specific documentation
for ptys

=cut
