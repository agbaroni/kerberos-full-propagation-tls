package io.github.agbaroni.tests.krb;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "words")
public class Word implements Serializable {
    private static final long serialVersionUID = 274839493832984L;

    @Id
    private int id;

    private String name;

    public int getId() {
	return id;
    }

    public String getName() {
	return name;
    }
}
