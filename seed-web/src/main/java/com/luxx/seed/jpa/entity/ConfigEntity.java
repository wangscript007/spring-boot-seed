package com.luxx.seed.jpa.entity;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "tb_config")
@Accessors(chain = true)
public class ConfigEntity extends BaseEntity implements Serializable {
    private String name;

    private String value;

    @Column(name = "is_array")
    private Boolean isArray;

    private String type;

    private String des;

    @Column(name = "update_time")
    private Date updateTime;
}