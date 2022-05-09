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

    // @Resource(lookup = "java:/jdbc/Database")
    // private DataSource dataSource;

    // @PersistenceUnit(unitName = "database")
    // private EntityManagerFactory entityManagerFactory;

    @PersistenceContext(unitName = "database1")
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
	String word = "hola";

	// properties.put("javax.persistence.jdbc.user", context.getCallerPrincipal().getName());
	// properties.put("hibernate.connection.username", context.getCallerPrincipal().getName());

	// entityManager = entityManagerFactory.createEntityManager(properties);

	System.out.println("@@@ " + entityManager);

	//w = entityManager.find(Word.class, new Integer(0));
  //TypedQuery<Word> query = entityManager.createQuery("SELECT w FROM Word w WHERE w.id = 0", Word.class);
  //List<Word> words = query.getResultList();

	//System.out.println("@@@ " + words.size());

  //if (words.size() != 0) {
	 // word = words.get(0).getName();
  //}

	// entityManager.close();

	return word;
    }
}
