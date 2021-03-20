######################################################################
#<
#
# Function: str key_id = p6_cirrus_kms_key_make(account_id, key_description, key_alias)
#
#  Args:
#	account_id -
#	key_description -
#	key_alias -
#
#  Returns:
#	str - key_id
#
#>
######################################################################
p6_cirrus_kms_key_make() {
    local account_id="$1"
    local key_description="$2"
    local key_alias="$3"

    local key_admin_principals="arn:aws:iam::${account_id}:role/SSO/SSO_Admin"
    local key_user_principals="arn:aws:iam::${account_id}:role/SSO/SSO_Admin"

    local key_policy=$(p6_aws_util_template_process "iam/kms" "ACCOUNT_ID=$account_id" "KEY_ADMIN_PRINCIPALS=$key_admin_principals" "KEY_USER_PRINCIPALS=$key_user_principals")

    local key_id=$(p6_aws_cmd kms create-key "$key_description" "$key_policy")
    p6_aws_cmd kms alias-key "$key_alias" "$key_id"

    p6_return_str "$key_id"
}
