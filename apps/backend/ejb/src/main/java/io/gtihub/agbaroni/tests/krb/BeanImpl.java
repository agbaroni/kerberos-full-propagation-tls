package io.github.agbaroni.tests.krb;

import java.io.Serializable;
import java.util.Properties;
import java.util.List;

import javax.annotation.Resource;
import javax.annotation.security.PermitAll;
import javax.ejb.EJBContext;
import javax.ejb.Remote;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.TypedQuery;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceProperty;
import javax.persistence.PersistenceUnit;
import javax.sql.DataSource;

import org.hibernate.SessionFactory;
import org.jboss.ejb3.annotation.SecurityDomain;

@PermitAll
@Remote(Bean.class)
@SecurityDomain("backend")
@Stateless
public class BeanImpl implements Bean {
    private static final long serialVersionUID = 283937163837382L;

    @Resource
    private EJBContext context;

    @PersistenceContext(unitName = "database1")
    private EntityManager entityManager;

    @Override
    public String getUser() throws Exception {
	return context.getCallerPrincipal().getName();
    }

    @Override
    public String getWord() throws Exception {
	Word w = null;
	String word = "hola";

	//System.out.println("@@@ " + entityManager);

	return word;
    }
}
