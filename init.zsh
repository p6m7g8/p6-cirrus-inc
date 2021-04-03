######################################################################
#<
#
# Function: p6df::modules::p6cirrus::deps()
#
#  Depends:	 p6_bootstrap
#>
######################################################################
p6df::modules::p6cirrus::deps() { ModuleDeps=(p6m7g8/p6types) }

######################################################################
#<
#
# Function: p6df::modules::p6cirrus::init()
#
#  Depends:	 p6_bootstrap
#  Environment:	 P6_DFZ_SRC_ORIGINAL_DIR
#>
######################################################################
p6df::modules::p6cirrus::init() {

  local dir="$P6_DFZ_SRC_ORIGINAL_DIR/p6-cirrus"

  p6_bootstrap "$dir"
}
