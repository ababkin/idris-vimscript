module Vimscript.FFI

import Builtins

mutual
  public export
  data VimFn t = MkVimFn t

  public export
  data VIM_FnTypes : Type -> Type where
    VIM_Fn : VIM_Types s -> VIM_FnTypes t -> VIM_FnTypes (s -> t)
    VIM_FnIO : VIM_Types t -> VIM_FnTypes (IO' l t)
    VIM_FnBase : VIM_Types t -> VIM_FnTypes t

  public export
  data VIM_Types : Type -> Type where
    VIM_Str    : VIM_Types String
    VIM_Int    : VIM_Types Int
    VIM_Ptr    : VIM_Types Ptr
    VIM_Raw    : VIM_Types (Raw a)
    VIM_Float  : VIM_Types Double
    VIM_Unit   : VIM_Types ()
    VIM_FnT    : VIM_FnTypes t -> VIM_Types (VimFn t)
    -- VIM_ArrayT : VIM_Types (VimArray t)

public export
data VIM_Foreign
  = VIM_Echo
  | VIM_ListEmpty
  | VIM_ListConcat
  | VIM_ListSetAt
  | VIM_BuiltIn String

%error_reverse
public export
FFI_VIM : FFI
FFI_VIM = MkFFI VIM_Types VIM_Foreign String

%error_reverse
public export
VIM_IO : Type -> Type
VIM_IO = IO' FFI_VIM

IO : Type -> Type
IO a = IO' FFI_VIM a

%inline
public export
vimCode : (ft : VIM_Foreign) -> (ty : Type) -> {auto fty : FTy FFI_VIM [] ty} -> ty
vimCode ft ty = foreign FFI_VIM ft ty