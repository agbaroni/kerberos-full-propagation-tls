package io.github.agbaroni.tests.krb;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

@Path("/local")
public class LocalTest {

    @Context
    private HttpServletRequest request;

    @GET
    public String getUser() throws Exception {
	return request.getRemoteUser();
    }
}
