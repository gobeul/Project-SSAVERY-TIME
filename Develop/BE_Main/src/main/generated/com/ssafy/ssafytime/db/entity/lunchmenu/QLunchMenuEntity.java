package com.ssafy.ssafytime.db.entity.lunchmenu;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QLunchMenuEntity is a Querydsl query type for LunchMenuEntity
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QLunchMenuEntity extends EntityPathBase<LunchMenuEntity> {

    private static final long serialVersionUID = -44685384L;

    public static final QLunchMenuEntity lunchMenuEntity = new QLunchMenuEntity("lunchMenuEntity");

    public final NumberPath<Integer> cho = createNumber("cho", Integer.class);

    public final StringPath course = createString("course");

    public final StringPath date = createString("date");

    public final NumberPath<Integer> fat = createNumber("fat", Integer.class);

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final StringPath imageUrl = createString("imageUrl");

    public final NumberPath<Integer> kcal = createNumber("kcal", Integer.class);

    public final StringPath mainMenu = createString("mainMenu");

    public final NumberPath<Integer> protein = createNumber("protein", Integer.class);

    public final NumberPath<Integer> region = createNumber("region", Integer.class);

    public final StringPath sideMenu = createString("sideMenu");

    public final NumberPath<Integer> sodium = createNumber("sodium", Integer.class);

    public QLunchMenuEntity(String variable) {
        super(LunchMenuEntity.class, forVariable(variable));
    }

    public QLunchMenuEntity(Path<? extends LunchMenuEntity> path) {
        super(path.getType(), path.getMetadata());
    }

    public QLunchMenuEntity(PathMetadata metadata) {
        super(LunchMenuEntity.class, metadata);
    }

}

