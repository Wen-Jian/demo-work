module ConstantDefinition
    USER_ROLE_ADMIN = 1
    USER_ROLE_AUTHORIZED_ADMIN = 2
    USER_ROLE_PRIME = 3
    USER_ROLE_NORMAL = 4
    USER_ROLE = {
        USER_ROLE_ADMIN => '最高管理者',
        USER_ROLE_AUTHORIZED_ADMIN => '一般管理者',
        USER_ROLE_PRIME => '高級使用者',
        USER_ROLE_NORMAL => '一般使用者'
    }
end