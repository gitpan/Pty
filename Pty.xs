#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include <sys/stropts.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>

/******************************************************************************/

#define RETCONST(n, s) if(strEQ(n, #s)) return(s)
static char *zero_but_true = "0 but true";

static double constant(char *name, int arg)
{
if (! (*name == 'I' && *(name + 1) == '_'))
   {
   errno = ENOENT;
   return 0;
   }
errno = 0;
switch(*(name + 2))
   {
   case 'A':
      RETCONST(name, I_ATMARK);
      break;
   case 'C':
      RETCONST(name, I_CANPUT);
      RETCONST(name, I_CKBAND);
      break;
   case 'E':
      RETCONST(name, I_EGETSIG);
      RETCONST(name, I_ESETSIG);
      break;
   case 'F':
      RETCONST(name, I_FDINSERT);
      RETCONST(name, I_FIND);
      RETCONST(name, I_FLUSH);
      RETCONST(name, I_FLUSHBAND);
      break;
   case 'G':
      RETCONST(name, I_GERROPT);
      RETCONST(name, I_GETBAND);
      RETCONST(name, I_GETCLTIME);
      RETCONST(name, I_GETSIG);
      RETCONST(name, I_GRDOPT);
      RETCONST(name, I_GWROPT);
      break;
   case 'L':
      RETCONST(name, I_LINK);
      RETCONST(name, I_LIST);
      RETCONST(name, I_LOOK);
      break;
   case 'N':
      RETCONST(name, I_NREAD);
      break;
   case 'P':
      RETCONST(name, I_PEEK);
      RETCONST(name, I_PLINK);
      RETCONST(name, I_POP);
      RETCONST(name, I_PUNLINK);
      RETCONST(name, I_PUSH);
      break;
   case 'R':
      RETCONST(name, I_RECVFD);
      break;
   case 'S':
      RETCONST(name, I_SENDFD);
      RETCONST(name, I_SERROPT);
      RETCONST(name, I_SETCLTIME);
      RETCONST(name, I_SETSIG);
      RETCONST(name, I_SRDOPT);
      RETCONST(name, I_STR);
      RETCONST(name, I_SWROPT);
      break;
   case 'U':
      RETCONST(name, I_UNLINK);
      break;
   }
errno = ENOENT;
return 0;
}

/******************************************************************************/

MODULE = Pty		PACKAGE = Pty		

PROTOTYPES: ENABLE

double
constant(name, arg)
	char* name
	int arg

SV *
ptsname(filedes)
	FILE *filedes
PREINIT:
	char *retval;
CODE:
	{
	ST(0) = sv_newmortal();
	if (retval = ptsname(fileno(filedes))) { sv_setpv(ST(0), retval); }
	else { ST(0) = &sv_undef; }
	}

SV *
grantpt(filedes)
	FILE *filedes
PREINIT:
	int fno, fflags, retval;
CODE:
	{
	# We have to clear the close-on-exec flag to make sure the fd is
	# passed to the child process created by the call to ptsname()
	fno = fileno(filedes);
	fflags = fcntl(fno, F_GETFD);
	fcntl(fno, F_SETFD, fflags & ~FD_CLOEXEC);
	retval = grantpt(fno);
	fcntl(fno, F_SETFD, fflags);
	ST(0) = sv_newmortal();
	if (retval == -1) { ST(0) = &sv_undef; }
	else if (retval != 0) { sv_setiv(ST(0), retval); }
	else { sv_setpv(ST(0), zero_but_true); }
	}

int
unlockpt(filedes)
	FILE *filedes
PREINIT:
	int retval;
CODE:
	{
	retval = unlockpt(fileno(filedes));
	ST(0) = sv_newmortal();
	if (retval == -1) { ST(0) = &sv_undef; }
	else if (retval != 0) { sv_setiv(ST(0), retval); }
	else { sv_setpv(ST(0), zero_but_true); }
	}
