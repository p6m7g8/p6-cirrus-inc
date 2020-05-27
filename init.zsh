p6df::modules::p6-cirrus-inc::version() { echo "0.0.1"; }
p6df::modules::p6-cirrus-inc::deps() { ModuleDeps=(p6m7g8/p6types) }
p6df::modules::p6-cirrus-inc::init() {

  local dir="$P6_DFZ_SRC_DIR/p6m7g8/p6-cirrus-inc"

  p6_bootstrap "$dir"
}
