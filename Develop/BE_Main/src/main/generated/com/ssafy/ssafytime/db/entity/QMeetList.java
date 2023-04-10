package com.ssafy.ssafytime.db.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QMeetList is a Querydsl query type for MeetList
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMeetList extends EntityPathBase<MeetList> {

    private static final long serialVersionUID = 112768564L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QMeetList meetList = new QMeetList("meetList");

    public final StringPath category = createString("category");

    public final QUser managerId;

    public final StringPath meetUrl = createString("meetUrl");

    public final StringPath reject = createString("reject");

    public final DatePath<java.time.LocalDate> rezDate = createDate("rezDate", java.time.LocalDate.class);

    public final NumberPath<Long> rezIdx = createNumber("rezIdx", Long.class);

    public final NumberPath<Double> rezTime = createNumber("rezTime", Double.class);

    public final NumberPath<Long> state = createNumber("state", Long.class);

    public final QUser studentId;

    public final StringPath title = createString("title");

    public QMeetList(String variable) {
        this(MeetList.class, forVariable(variable), INITS);
    }

    public QMeetList(Path<? extends MeetList> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QMeetList(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QMeetList(PathMetadata metadata, PathInits inits) {
        this(MeetList.class, metadata, inits);
    }

    public QMeetList(Class<? extends MeetList> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.managerId = inits.isInitialized("managerId") ? new QUser(forProperty("managerId")) : null;
        this.studentId = inits.isInitialized("studentId") ? new QUser(forProperty("studentId")) : null;
    }

}

