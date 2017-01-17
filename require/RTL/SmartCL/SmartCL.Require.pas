{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) The Smart Company AS. All rights reserved.                     }
{                                                                              }
{ **************************************************************************** }
unit SmartCL.Require;

interface

uses W3C.DOM, System.Types, system.reader;

type

EW3RequireJS = class(EW3Exception);

TRequireError = class(TJsErrorObject)
  property requireType: string;
  property requireModules: TStrArray;
end;

TW3RequireErrHandler = procedure (&error: TRequireError);

TW3RequireJSConfig = class external "requirejs.config"
  property enforceDefine: boolean;
  property baseUrl: string;
  property paths[name: string]: variant;
  property waitSeconds: integer;
end;

TW3RequireJS = class external "requirejs"
  property config: TW3RequireJSConfig;
  property onError: TW3RequireErrHandler;
end;

function Require: TW3RequireJS; overload;
procedure Require(Files: TStrArray); overload;
procedure Require(Files: TStrArray; const Success: TProcedureRef); overload;
procedure Require(Files: TStrArray; const Success: TProcedureRef;
  const Failure: TW3RequireErrHandler); overload;

implementation

{$R "require.js"}

function Require: TW3RequireJS;
begin
  try
    asm
    @result = require;
    end;
  except
    on e: exception do
    raise EW3RequireJS.Create({$I %FUNCTION%}, nil, e.message);
  end;
end;

procedure Require(Files: Array of string);
begin
  try
    asm
    require(@files);
    end;
  except
    on e: exception do
    raise EW3RequireJS.Create({$I %FUNCTION%}, nil, e.message);
  end;
end;

procedure Require(Files: TStrArray; const Success: TProcedureRef);
begin
  try
    asm
      require(@Files, @Success);
    end;
  except
    on e: exception do
    raise EW3RequireJS.Create({$I %FUNCTION%}, nil, e.message);
  end;
end;

procedure Require(Files: TStrArray; const Success: TProcedureRef;
  const Failure: TW3RequireErrHandler);
begin
  try
    asm
    require(@Files, @Success, @Failure);
    end;
  except
    on e: exception do
    raise EW3RequireJS.Create({$I %FUNCTION%}, nil, e.message);
  end;
end;

initialization
begin
  // When you compile a smart program, it will copy all files imported with
  // the $R compiler define, these will be stored in the $AppName/Res folder
  // and are loaded automatically.
  // Since that is the place you want to store other scripts as well, we
  // create an alias for the location. So $scripts will always point to
  // that path. You can add as many aliases you wish
  require.config.enforceDefine := false;
  require.config.paths['$scripts'] := '/res/';
end;


end.
