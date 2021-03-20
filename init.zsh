######################################################################
#<
#
# Function: p6df::modules::p6cirrus::deps()
#
#>
######################################################################
p6df::modules::p6cirrus::deps() { ModuleDeps=(p6m7g8/p6types) }

######################################################################
#<
#
# Function: p6df::modules::p6cirrus::init()
#
#>
######################################################################
p6df::modules::p6cirrus::init() {

  local dir="$P6_DFZ_SRC_DIR/p6m7g8/p6-cirrus"

  p6_bootstrap "$dir"
}
