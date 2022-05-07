package io.github.agbaroni.tests.krb;

import java.io.Serializable;

import javax.ejb.Remote;

@Remote
public interface Bean extends Serializable {
    String getUser() throws Exception;

    String getWord() throws Exception;
}
