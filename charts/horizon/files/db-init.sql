create table if not exists tb_collection
(
    id            bigint(20) unsigned auto_increment
        primary key,
    resource_id   bigint(20) unsigned default 0         not null comment 'refer to resource id',
    resource_type varchar(128)        default 'clusters' not null  comment 'resource type, cluster or application',
    user_id       bigint(20) unsigned default 0         not null comment 'refer to user id',
    constraint uk_resource_user
        unique (resource_id, user_id, resource_type)
);

create table if not exists tb_application
(
    id               bigint unsigned auto_increment
        primary key,
    group_id         bigint unsigned                           not null comment 'group id',
    name             varchar(64)     default ''                not null comment 'the name of application',
    description      varchar(256)                              null comment 'the description of application',
    priority         varchar(16)     default 'P3'              not null comment 'the priority of application',
    git_url          varchar(128)                              null comment 'git repo url',
    git_subfolder    varchar(128)                              null comment 'git repo subfolder',
    git_branch       varchar(128)                              null comment 'git default branch',
    git_ref          varchar(128)                              null,
    git_ref_type     varchar(64)                               null,
    template         varchar(64)                               not null comment 'template name',
    template_release varchar(64)                               not null comment 'template release',
    created_at       datetime        default CURRENT_TIMESTAMP not null,
    updated_at       datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts       bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by       bigint unsigned default 0                 not null comment 'creator',
    updated_by       bigint unsigned default 0                 not null comment 'updater',
    constraint uk_name_deletedTs
        unique (name, deleted_ts)
);

create table if not exists tb_application_region
(
    id               bigint unsigned auto_increment
        primary key,
    application_id   bigint unsigned                           not null comment 'application id',
    environment_name varchar(128)    default ''                not null comment 'environment name',
    region_name      varchar(128)    default ''                not null comment 'default deploy region of the environment',
    created_at       datetime        default CURRENT_TIMESTAMP not null,
    updated_at       datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    created_by       bigint unsigned default 0                 not null comment 'creator',
    updated_by       bigint unsigned default 0                 not null comment 'updater',
    constraint idx_application_environment
        unique (application_id, environment_name)
);

create table if not exists tb_cluster
(
    id               bigint unsigned auto_increment
        primary key,
    application_id   bigint unsigned                           not null comment 'application id',
    name             varchar(64)     default ''                not null comment 'the name of cluster',
    environment_name varchar(128)    default ''                not null,
    region_name      varchar(128)    default ''                not null,
    description      varchar(256)                              null comment 'the description of cluster',
    git_url          varchar(128)                              null comment 'git repo url',
    git_subfolder    varchar(128)                              null comment 'git repo subfolder',
    git_branch       varchar(128)                              null comment 'git branch',
    git_ref          varchar(128)                              null,
    git_ref_type     varchar(64)                               null,
    template         varchar(64)                               not null comment 'template name',
    template_release varchar(64)                               not null comment 'template release',
    created_at       datetime        default CURRENT_TIMESTAMP not null,
    updated_at       datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts       bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by       bigint unsigned default 0                 not null comment 'creator',
    updated_by       bigint unsigned default 0                 not null comment 'updater',
    status           varchar(64)                               null,
    expire_seconds   bigint unsigned default 0                 not null comment 'expiration seconds, 0 means permanent',
    constraint uk_name_deletedTs
        unique (name, deleted_ts)
);

create index idx_application_id
    on tb_cluster (application_id);

create index idx_deleted_ts
    on tb_cluster (deleted_ts);

create index idx_region_deleted_ts
    on tb_cluster (region_name, deleted_ts);

create table if not exists tb_cluster_template_schema_tag
(
    id         bigint unsigned auto_increment
        primary key,
    cluster_id bigint unsigned                           not null comment 'cluster id',
    tag_key    varchar(64)     default ''                not null comment 'key of tag',
    tag_value  varchar(1280)   default ''                not null comment 'value of tag',
    created_at datetime        default CURRENT_TIMESTAMP not null,
    updated_at datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    created_by bigint unsigned default 0                 not null comment 'creator',
    updated_by bigint unsigned default 0                 not null comment 'updater',
    constraint idx_cluster_id_key
        unique (cluster_id, tag_key)
);

create index idx_key
    on tb_cluster_template_schema_tag (tag_key);

create table if not exists tb_environment
(
    id           bigint unsigned auto_increment
        primary key,
    name         varchar(128)    default ''                not null comment 'env name',
    display_name varchar(128)    default ''                not null comment 'display name',
    created_at   datetime        default CURRENT_TIMESTAMP not null,
    updated_at   datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts   bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by   bigint unsigned default 0                 not null comment 'creator',
    updated_by   bigint unsigned default 0                 not null comment 'updater',
    auto_free    tinyint(1)      default 0                 not null comment 'auto free configuration, 0 means disabled',
    constraint uk_name_deletedTs
        unique (name, deleted_ts)
);

create table if not exists tb_environment_region
(
    id               bigint unsigned auto_increment
        primary key,
    environment_name varchar(128)    default ''                not null comment 'environment name',
    region_name      varchar(128)    default ''                not null comment 'region name',
    is_default       tinyint(1)      default 0                 not null comment '0 means not default region, 1 means default region',
    disabled         tinyint(1)      default 0                 not null comment 'is disabled，0-false，1-true',
    created_at       datetime        default CURRENT_TIMESTAMP not null,
    updated_at       datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts       bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by       bigint unsigned default 0                 not null comment 'creator',
    updated_by       bigint unsigned default 0                 not null comment 'updater',
    constraint uk_env_region_deletedTs
        unique (environment_name, region_name, deleted_ts)
);

create table if not exists tb_event
(
    id            bigint unsigned auto_increment
        primary key,
    req_id        varchar(256)    default ''                not null,
    resource_type varchar(256)    default ''                not null comment 'currently support: groups, applications, clusters',
    resource_id   varchar(256)    default ''                not null comment 'id of resource',
    event_type    varchar(256)    default ''                not null comment 'type of event',
    created_at    datetime        default CURRENT_TIMESTAMP not null,
    created_by    bigint unsigned default 0                 not null
);

create index idx_req_id
    on tb_event (req_id);

create index idx_resource_action
    on tb_event (resource_id, resource_type, event_type);

create table if not exists tb_event_cursor
(
    id         bigint unsigned auto_increment
        primary key,
    position   bigint   default 0                 not null comment 'the event id of the last processing completed',
    created_at datetime default CURRENT_TIMESTAMP not null,
    updated_at datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create table if not exists tb_group
(
    id               bigint unsigned auto_increment
        primary key,
    name             varchar(128)    default ''                not null,
    path             varchar(32)     default ''                not null,
    description      varchar(256)                              null,
    visibility_level varchar(16)                               not null comment 'public or private',
    parent_id        bigint          default 0                 not null comment 'ID of the parent group',
    traversal_ids    varchar(32)     default ''                not null comment 'ID path from the root, like 1,2,3',
    region_selector  varchar(512)    default ''                not null comment 'used for filtering kubernetes',
    created_at       datetime        default CURRENT_TIMESTAMP not null,
    updated_at       datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts       bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by       bigint unsigned default 0                 not null comment 'creator',
    updated_by       bigint unsigned default 0                 not null comment 'updater',
    constraint uk_parentId_name_deletedTs
        unique (parent_id, name, deleted_ts),
    constraint uk_parentId_path_deletedTs
        unique (parent_id, path, deleted_ts)
);

create table if not exists tb_identity_provider
(
    id                         bigint unsigned auto_increment
        primary key,
    display_name               varchar(128)    default ''                           not null comment 'name displayed on web',
    name                       varchar(128)    default ''                           not null comment 'name to generate index in db, unique',
    avatar                     varchar(256)    default ''                           not null comment 'link to avatar',
    authorization_endpoint     varchar(256)    default ''                           not null comment 'authorization endpoint of idp',
    token_endpoint             varchar(256)    default ''                           not null comment 'token endpoint of idp',
    userinfo_endpoint          varchar(256)    default ''                           not null comment 'userinfo endpoint of idp',
    revocation_endpoint        varchar(256)    default ''                           not null comment 'revocation endpoint of idp',
    issuer                     varchar(256)    default ''                           not null comment 'issuer of idp, generating discovery endpoint',
    scopes                     varchar(256)    default ''                           not null comment 'scopes when asking for authorization',
    token_endpoint_auth_method varchar(256)    default 'client_secret_sent_as_post' not null comment 'how to carry client secret',
    jwks                       varchar(256)    default ''                           not null comment 'jwks endpoint, describe how to identify a token',
    client_id                  varchar(256)    default ''                           not null comment 'client id issued by idp',
    client_secret              varchar(256)    default ''                           not null comment 'client secret issued by idp',
    created_at                 datetime        default CURRENT_TIMESTAMP            not null comment 'time of first creating',
    updated_at                 datetime        default CURRENT_TIMESTAMP            not null on update CURRENT_TIMESTAMP comment 'time of last updating',
    deleted_ts                 bigint          default 0                            null comment 'deleted timestamp, 0 means not deleted',
    created_by                 bigint unsigned default 0                            not null comment 'creator',
    updated_by                 bigint unsigned default 0                            not null comment 'updater',
    signing_algs               varchar(256)    default ''                           not null comment 'algs for verifying signing',
    constraint uk_name
        unique (name)
);

create table if not exists tb_idp_user
(
    id         bigint unsigned auto_increment
        primary key,
    sub        varchar(256)    default ''                not null comment 'user id in idp',
    idp_id     bigint          default 0                 not null comment 'refer to tb_identify_provider',
    user_id    bigint          default 0                 not null comment 'refer to tb_user',
    name       varchar(256)    default ''                not null comment 'user name from idp',
    email      varchar(256)    default ''                not null comment 'user email from idp',
    deletable  tinyint(1)      default 0                 not null comment 'whether this link can be deleted',
    created_at datetime        default CURRENT_TIMESTAMP not null comment 'time of first creating',
    updated_at datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment 'time of last updating',
    deleted_ts bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by bigint unsigned default 0                 not null comment 'creator',
    updated_by bigint unsigned default 0                 not null comment 'updater',
    constraint uni_idx_idp_sub
        unique (idp_id, sub, deleted_ts)
);

create table if not exists tb_member
(
    id            bigint unsigned auto_increment
        primary key,
    resource_type varchar(64)                          not null comment 'groupapplicationcluster',
    resource_id   bigint unsigned                      not null comment 'resource id',
    role          varchar(64)                          not null comment 'binding role name',
    member_type   tinyint(1) default 0                 not null comment '0-USER, 1-group',
    membername_id bigint unsigned                      not null comment 'UserID or GroupID',
    granted_by    bigint unsigned                      not null comment 'who grant the role',
    created_by    bigint unsigned                      not null comment 'who create the role',
    created_at    datetime   default CURRENT_TIMESTAMP not null,
    updated_at    datetime   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts    bigint     default 0                 not null comment 'deleted timestamp, 0 means not deleted',
    constraint uk_resource_member_deleted
        unique (resource_type, resource_id, member_type, membername_id, deleted_ts)
);

create table if not exists tb_oauth_app
(
    id           bigint unsigned auto_increment
        primary key,
    name         varchar(128)                              null comment 'short name of app client',
    client_id    varchar(128)                              null comment 'oauth app client',
    redirect_url varchar(256)                              null comment 'the authorization callback url',
    home_url     varchar(256)                              null comment 'the oauth app home url',
    description  varchar(256)                              null comment 'the desc of app',
    app_type     tinyint(1)      default 1                 not null comment '1 for HorizonOAuthAPP, 2 for DirectOAuthAPP',
    owner_type   tinyint(1)      default 1                 not null comment '1 for group, 2 for user',
    owner_id     bigint                                    null comment 'group owner id',
    created_at   datetime        default CURRENT_TIMESTAMP not null comment 'created_at',
    created_by   bigint unsigned default 0                 not null comment 'creator',
    updated_at   datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    updated_by   bigint unsigned default 0                 not null comment 'updater',
    constraint idx_client_id
        unique (client_id)
);

create table if not exists tb_oauth_client_secret
(
    id            bigint unsigned auto_increment
        primary key,
    client_id     varchar(256)                              null comment 'oauth app client',
    client_secret varchar(256)                              null comment 'oauth app secret',
    created_at    datetime        default CURRENT_TIMESTAMP not null,
    created_by    bigint unsigned default 0                 not null comment 'creator',
    constraint idx_client_id_secret
        unique (client_id, client_secret)
);

create table if not exists tb_pipeline
(
    id             bigint unsigned auto_increment
        primary key,
    pipelinerun_id bigint unsigned                       not null comment 'pipelinerun id',
    application    varchar(64)                           not null comment 'application name',
    cluster        varchar(64)                           not null comment 'cluster name',
    region         varchar(16)                           not null comment 'region name',
    pipeline       varchar(16) default ''                not null comment 'pipeline name',
    result         varchar(16) default ''                not null comment 'result of the step, ok、failed or others',
    duration       int(16)                               not null comment 'duration',
    started_at     datetime                              not null comment 'start time of this pipelinerun',
    finished_at    datetime                              not null comment 'finish time of this pipelinerun',
    created_at     datetime    default CURRENT_TIMESTAMP not null,
    updated_at     datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create index idx_application_cluster
    on tb_pipeline (application, cluster);

create index idx_region_application_created_at
    on tb_pipeline (region, application, created_at);

create table if not exists tb_pipelinerun
(
    id                 bigint unsigned auto_increment
        primary key,
    cluster_id         bigint unsigned                           not null comment 'cluster id',
    action             varchar(64)                               not null comment 'action',
    status             varchar(64)     default ''                not null comment 'the pipelinerun status',
    title              varchar(256)    default ''                not null comment 'the title of pipelinerun',
    description        varchar(2048)                             null comment 'the description of pipelinerun',
    git_url            varchar(128)                              null comment 'git repo url',
    git_branch         varchar(128)                              null comment 'the branch to build of this pipelinerun',
    git_ref            varchar(128)                              null,
    git_ref_type       varchar(64)                               null,
    git_commit         varchar(128)                              null comment 'the commit to build of this pipelinerun',
    image_url          varchar(256)                              null comment 'image url',
    last_config_commit varchar(128)                              null comment 'the last commit of cluster config',
    config_commit      varchar(128)                              null comment 'the new commit of cluster config',
    s3_bucket          varchar(128)    default ''                not null comment 's3 bucket to storage this pipelinerun log',
    log_object         varchar(258)    default ''                not null comment 's3 object for log',
    pr_object          varchar(258)    default ''                not null comment 's3 object for pipelinerun',
    started_at         datetime                                  null comment 'start time of this pipelinerun',
    finished_at        datetime                                  null comment 'finish time of this pipelinerun',
    rollback_from      bigint unsigned                           null comment 'the pipelinerun id that this pipelinerun rollback from',
    created_at         datetime        default CURRENT_TIMESTAMP not null,
    updated_at         datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    created_by         bigint unsigned default 0                 not null comment 'creator',
    ci_event_id        varchar(36)     default ''                not null
);

create index idx_ci_event_id
    on tb_pipelinerun (ci_event_id);

create index idx_cluster_action
    on tb_pipelinerun (cluster_id, action);

create index idx_cluster_config_commit
    on tb_pipelinerun (cluster_id, config_commit);

create table if not exists tb_region
(
    id             bigint unsigned auto_increment
        primary key,
    name           varchar(128)    default ''                not null comment 'region name',
    display_name   varchar(128)    default ''                not null comment 'region display name',
    server         varchar(256)                              null comment 'k8s server url',
    certificate    text                                      null comment 'k8s kube config',
    ingress_domain text                                      null comment 'k8s ingress domain',
    disabled       tinyint(1)      default 0                 not null comment '0 means not disabled, 1 means disabled',
    created_at     datetime        default CURRENT_TIMESTAMP not null,
    updated_at     datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts     bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by     bigint unsigned default 0                 not null comment 'creator',
    updated_by     bigint unsigned default 0                 not null comment 'updater',
    prometheus_url varchar(128)                              null comment 'prometheus url',
    registry_id    bigint unsigned default 0                 not null comment 'registry id',
    constraint idx_name
        unique (name)
);

create table if not exists tb_registry
(
    id                       bigint unsigned auto_increment
        primary key,
    name                     varchar(128)    default ''                not null comment 'name of the registry',
    server                   varchar(256)    default ''                not null comment 'registry server address',
    token                    varchar(512)    default ''                not null comment 'registry server token',
    path                     varchar(256)    default ''                not null comment 'path of image',
    insecure_skip_tls_verify tinyint(1)      default 0                 not null comment 'skip tls verify',
    kind                     varchar(256)    default 'harbor'          not null comment 'which kind registry it is',
    created_at               datetime        default CURRENT_TIMESTAMP not null,
    updated_at               datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts               bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by               bigint unsigned default 0                 not null comment 'creator',
    updated_by               bigint unsigned default 0                 not null comment 'updater'
);

create table if not exists tb_step
(
    id             bigint unsigned auto_increment
        primary key,
    pipelinerun_id bigint unsigned                       not null comment 'pipelinerun id',
    application    varchar(64)                           not null comment 'application name',
    cluster        varchar(64)                           not null comment 'cluster name',
    region         varchar(16)                           not null comment 'region name',
    pipeline       varchar(16) default ''                not null comment 'pipeline name',
    task           varchar(16) default ''                not null comment 'task name',
    step           varchar(16) default ''                not null comment 'step name',
    result         varchar(16) default ''                not null comment 'result of the step, ok or failed',
    duration       int(16)                               not null comment 'duration',
    started_at     datetime                              not null comment 'start time of this pipelinerun',
    finished_at    datetime                              not null comment 'finish time of this pipelinerun',
    created_at     datetime    default CURRENT_TIMESTAMP not null,
    updated_at     datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create index idx_pipelinerun_id
    on tb_step (pipelinerun_id);

create index idx_region_application_created_at
    on tb_step (region, application, created_at);

create table if not exists tb_tag
(
    id            bigint unsigned auto_increment
        primary key,
    resource_id   bigint unsigned                           not null comment 'resource id',
    resource_type varchar(64)     default ''                not null comment 'resource type',
    tag_key       varchar(64)     default ''                not null comment 'key of tag',
    tag_value     varchar(1280)   default ''                not null comment 'value of tag',
    created_at    datetime        default CURRENT_TIMESTAMP not null,
    updated_at    datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    created_by    bigint unsigned default 0                 not null comment 'creator',
    updated_by    bigint unsigned default 0                 not null comment 'updater',
    constraint uk_rType_cId_tKey
        unique (resource_type, resource_id, tag_key)
);

create index idx_cluster_id
    on tb_tag (resource_id);

create index idx_key
    on tb_tag (tag_key);

create table if not exists tb_task
(
    id             bigint unsigned auto_increment
        primary key,
    pipelinerun_id bigint unsigned                       not null comment 'pipelinerun id',
    application    varchar(64)                           not null comment 'application name',
    cluster        varchar(64)                           not null comment 'cluster name',
    region         varchar(16)                           not null comment 'region name',
    pipeline       varchar(16) default ''                not null comment 'pipeline name',
    task           varchar(16) default ''                not null comment 'task name',
    result         varchar(16) default ''                not null comment 'result of the step, ok or failed',
    duration       int(16)                               not null comment 'duration',
    started_at     datetime                              not null comment 'start time of this pipelinerun',
    finished_at    datetime                              not null comment 'finish time of this pipelinerun',
    created_at     datetime    default CURRENT_TIMESTAMP not null,
    updated_at     datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create index idx_pipelinerun_id
    on tb_task (pipelinerun_id);

create index idx_region_application_created_at
    on tb_task (region, application, created_at);

create table if not exists tb_template
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(64)     default ''                not null comment 'the name of template',
    description varchar(256)                              null comment 'the template description',
    created_at  datetime        default CURRENT_TIMESTAMP not null,
    updated_at  datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts  bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by  bigint unsigned default 0                 not null comment 'creator',
    updated_by  bigint unsigned default 0                 not null comment 'updater',
    repository  varchar(256)    default ''                not null,
    group_id    bigint unsigned default 0                 not null,
    chart_name  varchar(256)    default ''                null,
    only_admin  tinyint(1)      default 0                 not null,
    only_owner  tinyint(1)      default 0                 not null comment 'only owner could access',
    without_ci  tinyint(1)      default 0                 not null comment 'without_ci configuration, 0 means with ci',
    constraint idx_name
        unique (name)
);

create table if not exists tb_template_release
(
    id            bigint unsigned auto_increment
        primary key,
    template_name varchar(64)                               not null comment 'the name of template',
    name          varchar(64)     default ''                not null comment 'the name of template release',
    description   varchar(256)                              not null comment 'description about this template release',
    recommended   tinyint(1)                                not null comment 'is the most recommended template, 0-false, 1-true',
    created_at    datetime        default CURRENT_TIMESTAMP not null,
    updated_at    datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts    bigint          default 0                 null comment 'deleted timestamp, 0 means not deleted',
    created_by    bigint unsigned default 0                 not null comment 'creator',
    updated_by    bigint unsigned default 0                 not null comment 'updater',
    template      bigint unsigned default 0                 not null,
    chart_name    varchar(256)    default ''                not null,
    only_admin    tinyint(1)      default 0                 not null,
    chart_version varchar(256)    default ''                not null comment 'chart version on template repository',
    sync_status   varchar(64)     default 'status_unknown'  not null comment 'shows sync status',
    failed_reason varchar(2048)   default ''                not null comment 'failed reason at last time',
    commit_id     varchar(256)    default ''                not null comment 'commit id at last sync',
    last_sync_at  datetime        default CURRENT_TIMESTAMP not null,
    only_owner    tinyint(1)      default 0                 not null comment 'only owner could access',
    constraint idx_template_name_name
        unique (template_name, name)
);

create table if not exists tb_token
(
    id           bigint unsigned auto_increment
        primary key,
    client_id    varchar(256)                              null comment 'oauth app client',
    redirect_uri varchar(256)                              null,
    state        varchar(256)                              null comment ' authorize_code state info',
    code         varchar(256)    default ''                not null comment 'private-token-code/authorize_code/access_token/refresh-token',
    created_at   datetime        default CURRENT_TIMESTAMP not null,
    expires_in   bigint                                    null,
    scope        varchar(256)                              null,
    user_id      bigint unsigned default 0                 not null,
    name         varchar(64)     default ''                not null,
    created_by   bigint unsigned default 0                 not null,
    constraint idx_code
        unique (code)
);

create index idx_client_id
    on tb_token (client_id);

create index idx_user_or_robot_identity
    on tb_token (user_id);

create table if not exists tb_user
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(64)         default ''                not null,
    full_name  varchar(128)        default ''                null,
    email      varchar(64)         default ''                not null,
    phone      varchar(32)                                   null,
    oidc_id    varchar(64)                                   not null comment 'oidc id, which is a unique index in oidc system.',
    oidc_type  varchar(64)                                   not null comment 'oidc type, such as netease, github, gitlab etc.',
    admin      tinyint(1)                                    not null comment 'is system admin，0-false，1-true',
    created_at datetime            default CURRENT_TIMESTAMP not null,
    updated_at datetime            default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    deleted_ts bigint              default 0                 null comment 'deleted timestamp, 0 means not deleted',
    banned     tinyint(1)          default 0                 not null comment 'whether user is banned',
    created_by bigint unsigned     default 0                 not null,
    user_type  tinyint(1) unsigned default 0                 not null,
    password   varchar(256)        default ''                not null comment 'password of user'
);

create index idx_email
    on tb_user (email);

create table if not exists tb_webhook
(
    id                 bigint unsigned auto_increment
        primary key,
    enabled            tinyint(1)      default 1                 not null,
    url                text                                      not null,
    ssl_verify_enabled tinyint(1)      default 0                 not null,
    description        varchar(256)    default ''                not null,
    secret             text                                      not null,
    triggers           text                                      not null,
    resource_type      varchar(256)    default ''                not null,
    resource_id        bigint          default 0                 not null,
    created_at         datetime        default CURRENT_TIMESTAMP not null,
    updated_at         datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    created_by         bigint unsigned default 0                 not null,
    updated_by         bigint unsigned default 0                 not null
);

create index idx_resource
    on tb_webhook (resource_id, resource_type);

create table if not exists tb_webhook_log
(
    id               bigint unsigned auto_increment
        primary key,
    webhook_id       bigint unsigned                           not null,
    event_id         bigint unsigned                           not null,
    url              text                                      not null,
    request_headers  text                                      not null,
    request_data     text                                      not null,
    response_headers text                                      not null,
    response_body    text                                      not null,
    status           varchar(256)                              not null,
    error_message    text                                      not null,
    created_at       datetime        default CURRENT_TIMESTAMP not null,
    created_by       bigint unsigned default 0                 not null,
    updated_at       datetime        default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create index idx_event_id
    on tb_webhook_log (event_id);

create index idx_webhook_id_status
    on tb_webhook_log (webhook_id, status);

-- init data
insert into tb_user (name, full_name, email, oidc_id, oidc_type, admin, banned, password)
values ('admin', 'admin', 'admin@cloudnative.com', 0, 0, 1, 0,
        '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
