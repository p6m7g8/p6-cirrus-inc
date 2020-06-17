######################################################################
#<
#
# Function: p6df::modules::p6-cirrus-inc::version()
#
#>
######################################################################
p6df::modules::p6-cirrus-inc::version() { echo "0.0.1"; }
######################################################################
#<
#
# Function: p6df::modules::p6-cirrus-inc::deps()
#
#>
######################################################################
p6df::modules::p6-cirrus-inc::deps() { ModuleDeps=(p6m7g8/p6types) }
######################################################################
#<
#
# Function: p6df::modules::p6-cirrus-inc::init()
#
#>
######################################################################
p6df::modules::p6-cirrus-inc::init() {

  local dir="$P6_DFZ_SRC_DIR/p6m7g8/p6-cirrus-inc"

  p6_bootstrap "$dir"
}