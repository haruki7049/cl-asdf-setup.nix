{
  lib,
}:

drv-list:

"${lib.strings.concatStringsSep ":" (
  builtins.map (drv: "${drv.CL_SOURCE_REGISTRY}") (drv-list or [ ])
)}"
