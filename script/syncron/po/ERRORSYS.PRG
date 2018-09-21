/***
*
*	Errorsys.prg
*
*  Standard Clipper error handler
*
*  Copyright (c) 1990-1993, Computer Associates International, Inc.
*  All rights reserved.
*
*  Compile:  /m /n /w
*
*/

#include "error.ch"


// put messages to STDERR
#command ? <list,...>   =>  ?? Chr(13) + Chr(10) ; ?? <list>
#command ?? <list,...>  =>  OutErr(<list>)


// used below
#define NTRIM(n)		( LTrim(Str(n)) )



/***
*	ErrorSys()
*
*	Note:  automatically executes at startup
*/

proc ErrorSys()
	ErrorBlock( {|e| DefError(e)} )
return




/***
*	DefError()
*/
static func DefError(e)
local i, cMessage, aOptions:={}, nChoice,n:=3



	// by default, division by zero yields zero
	if ( e:genCode == EG_ZERODIV )
		return (0)
	end


	// for network open error, set NETERR() and subsystem default
	if ( e:genCode == EG_OPEN .and. e:osCode == 32 .and. e:canDefault )

		NetErr(.t.)
		return (.f.)									// NOTE

	end


	// for lock error during APPEND BLANK, set NETERR() and subsystem default
	if ( e:genCode == EG_APPENDLOCK .and. e:canDefault )

		NetErr(.t.)
		return (.f.)									// NOTE

	end



	// build error message
	cMessage := ErrorMessage(e)


	// build options array
	// aOptions := {"Break", "Quit"}

	if (e:canRetry)
		AAdd(aOptions, "Retry")
	end

        AAdd(aOptions,"Exit")

	if (e:canDefault)
		AAdd(aOptions, "Default")
	end


	// put up alert box
	nChoice := 0
	while ( nChoice == 0 )
                Do case
                case ProcLine(3)>0 ;n:=3
                case ProcLine(4)>0 ;n:=4
                case ProcLine(5)>0 ;n:=5
                case ProcLine(6)>0 ;n:=6
                case ProcLine(7)>0 ;n:=7
                case ProcLine(8)>0 ;n:=8
                EndCase
		if ( Empty(e:osCode) )
//                      nChoice := Alert( cMessage, aOptions )
                        nChoice := Alert( cMessage + ;
                                   ";(Proc: " + ProcName(n)+' '+Str(ProcLine(n),5) + ")"+;
                                   ";"+Repl('-',Len(cMessage)), ;
                                      aOptions )
                                   lKeluar:=.T.
		else
                        nChoice := Alert( cMessage + ;
                                   ";(DOS Error " + NTRIM(e:osCode) + ")"+ ;
                                   ";(Proc: " + ProcName(n)+' '+Str(ProcLine(n),5) + ")"+ ;
                                   ";"+Repl('-',Len(cMessage)), ;
                                      aOptions )
                                   lKeluar:=.T.
		end


		if ( nChoice == NIL )
			exit
		end

	end


	if ( !Empty(nChoice) )

		// do as instructed
                if ( aOptions[nChoice] == "Exit" )
			Break(e)

		elseif ( aOptions[nChoice] == "Retry" )
			return (.t.)

		elseif ( aOptions[nChoice] == "Default" )
			return (.f.)

		end

	end


	// display message and traceback
	if ( !Empty(e:osCode) )
		cMessage += " (DOS Error " + NTRIM(e:osCode) + ") "
	end

	? cMessage
	i := 2
//      while ( !Empty(ProcName(i)) )
		? "Called from", Trim(ProcName(i)) + ;
			"(" + NTRIM(ProcLine(i)) + ")  "

		i++
//      end


	// give up
	ErrorLevel(1)
	QUIT

return (.f.)




/***
*	ErrorMessage()
*/
static func ErrorMessage(e)
local cMessage


	// start error message
	cMessage := if( e:severity > ES_WARNING, "Error ", "Warning " )


	// add subsystem name if available
	if ( ValType(e:subsystem) == "C" )
		cMessage += e:subsystem()
	else
		cMessage += "???"
	end


	// add subsystem's error code if available
	if ( ValType(e:subCode) == "N" )
		cMessage += ("/" + NTRIM(e:subCode))
	else
		cMessage += "/???"
	end


	// add error description if available
	if ( ValType(e:description) == "C" )
		cMessage += ("  " + e:description)
	end


	// add either filename or operation
	if ( !Empty(e:filename) )
		cMessage += (": " + e:filename)

	elseif ( !Empty(e:operation) )
		cMessage += (": " + e:operation)

	end


return (cMessage)

