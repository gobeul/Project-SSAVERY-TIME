package com.ssafy.ssafytime.db.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QAttendanceId is a Querydsl query type for AttendanceId
 */
@Generated("com.querydsl.codegen.DefaultEmbeddableSerializer")
public class QAttendanceId extends BeanPath<AttendanceId> {

    private static final long serialVersionUID = -1808539885L;

    public static final QAttendanceId attendanceId = new QAttendanceId("attendanceId");

    public final NumberPath<Integer> attendanceCategory = createNumber("attendanceCategory", Integer.class);

    public final SimplePath<java.util.TimeZone> attendanceDate = createSimple("attendanceDate", java.util.TimeZone.class);

    public final NumberPath<Long> userIdx = createNumber("userIdx", Long.class);

    public QAttendanceId(String variable) {
        super(AttendanceId.class, forVariable(variable));
    }

    public QAttendanceId(Path<? extends AttendanceId> path) {
        super(path.getType(), path.getMetadata());
    }

    public QAttendanceId(PathMetadata metadata) {
        super(AttendanceId.class, metadata);
    }

}

