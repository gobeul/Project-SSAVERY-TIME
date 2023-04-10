package com.ssafy.ssafytime.db.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "user")
@Getter
@Setter
@Builder
@DynamicInsert
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @Id
    @Column(name = "user_idx")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userIdx;

    @Column(name = "user_name", length = 50)
    private String userName;

    //    @Column(name = "user_password", length = 100)
//    @JsonIgnore
//    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
//    private String password;
    @Column(name = "password", length = 100)
    private String password;


    @Column(name = "user_email", length = 100)
    private String userEmail;


    @Column(name = "track_code")
    private  Integer trackCode;

    @Column(name = "class_num")
    private Integer classNum;

    @Column(name = "region_code")
    private Integer regionCode;

    @Column(name = "user_img")
    @Lob
    private String userImg;

    @Column(name="exp")
    @ColumnDefault("0")
    private Integer exp;

    @Column(name="mileage")
    @ColumnDefault("0")
    private Integer mileage;

    @Column(name="is_admin")
    @ColumnDefault("0")
    private Integer isAdmin;

    @Lob
    private String token;


    @ManyToMany
    @JoinTable(
            name = "user_authority",
            joinColumns = {@JoinColumn(name = "user_idx", referencedColumnName = "user_idx")},
            inverseJoinColumns = {@JoinColumn(name = "authority_name", referencedColumnName = "authority_name")})
    private Set<Authority> authorities;




}


