package io.github.agbaroni.tests.krb;

import java.io.Serializable;
import java.util.Properties;

import javax.annotation.Resource;
import javax.annotation.security.PermitAll;
import javax.ejb.EJBContext;
import javax.ejb.Remote;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
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

    // @Resource(lookup = "java:/jdbc/Database")
    // private DataSource dataSource;

    // @PersistenceUnit(unitName = "database")
    // private EntityManagerFactory entityManagerFactory;

    @PersistenceContext(unitName = "database")
    private EntityManager entityManager;

    // private void getBoh() throws Exception {
    // 	SessionFactory sessionFactory = entityManagerFactory.unwrap(SessionFactory.class);
    // }

    @Override
    public String getUser() throws Exception {
	return context.getCallerPrincipal().getName();
    }

    @Override
    public String getWord() throws Exception {
	// Properties properties = new Properties();
	// EntityManager entityManager;
	Word w = null;
	String word = null;

	// properties.put("javax.persistence.jdbc.user", context.getCallerPrincipal().getName());
	// properties.put("hibernate.connection.username", context.getCallerPrincipal().getName());

	// entityManager = entityManagerFactory.createEntityManager(properties);

	System.out.println("@@@ " + entityManager);

	w = entityManager.find(Word.class, new Integer(0));

	System.out.println("@@@ " + w);

	word = w.getName();

	// entityManager.close();

	return word;
    }
}
