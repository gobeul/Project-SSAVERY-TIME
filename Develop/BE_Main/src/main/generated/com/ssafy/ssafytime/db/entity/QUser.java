package com.ssafy.ssafytime.db.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QUser is a Querydsl query type for User
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QUser extends EntityPathBase<User> {

    private static final long serialVersionUID = 139957242L;

    public static final QUser user = new QUser("user");

    public final SetPath<Authority, QAuthority> authorities = this.<Authority, QAuthority>createSet("authorities", Authority.class, QAuthority.class, PathInits.DIRECT2);

    public final NumberPath<Integer> classNum = createNumber("classNum", Integer.class);

    public final NumberPath<Integer> exp = createNumber("exp", Integer.class);

    public final NumberPath<Integer> isAdmin = createNumber("isAdmin", Integer.class);

    public final NumberPath<Integer> mileage = createNumber("mileage", Integer.class);

    public final StringPath password = createString("password");

    public final StringPath refreshToken = createString("refreshToken");

    public final NumberPath<Integer> regionCode = createNumber("regionCode", Integer.class);

    public final NumberPath<Long> timeout = createNumber("timeout", Long.class);

    public final StringPath token = createString("token");

    public final NumberPath<Integer> trackCode = createNumber("trackCode", Integer.class);

    public final StringPath userEmail = createString("userEmail");

    public final NumberPath<Long> userIdx = createNumber("userIdx", Long.class);

    public final StringPath userImg = createString("userImg");

    public final StringPath userName = createString("userName");

    public QUser(String variable) {
        super(User.class, forVariable(variable));
    }

    public QUser(Path<? extends User> path) {
        super(path.getType(), path.getMetadata());
    }

    public QUser(PathMetadata metadata) {
        super(User.class, metadata);
    }

}

