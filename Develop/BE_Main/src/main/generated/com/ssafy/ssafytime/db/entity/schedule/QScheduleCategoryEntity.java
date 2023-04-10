package com.ssafy.ssafytime.db.entity.schedule;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QScheduleCategoryEntity is a Querydsl query type for ScheduleCategoryEntity
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QScheduleCategoryEntity extends EntityPathBase<ScheduleCategoryEntity> {

    private static final long serialVersionUID = 541803744L;

    public static final QScheduleCategoryEntity scheduleCategoryEntity = new QScheduleCategoryEntity("scheduleCategoryEntity");

    public final StringPath category = createString("category");

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public QScheduleCategoryEntity(String variable) {
        super(ScheduleCategoryEntity.class, forVariable(variable));
    }

    public QScheduleCategoryEntity(Path<? extends ScheduleCategoryEntity> path) {
        super(path.getType(), path.getMetadata());
    }

    public QScheduleCategoryEntity(PathMetadata metadata) {
        super(ScheduleCategoryEntity.class, metadata);
    }

}

