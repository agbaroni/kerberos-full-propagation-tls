package io.github.agbaroni.tests.krb;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "words")
public class Word implements Serializable {
    private static final long serialVersionUID = 274839493832984L;

    @Id
    @Column(name = "id")
    private int id;

    @Column(name = "name")
    private String name;

    public int getId() {
	return id;
    }

    public String getName() {
	return name;
    }

    public void setId(int id) {
       this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }
}
