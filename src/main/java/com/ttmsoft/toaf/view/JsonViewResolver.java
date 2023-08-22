/*
 * TCJUG Spring MVC Demo Application - by Bob McCune
 * May 2009
 */
package com.ttmsoft.toaf.view;

import org.springframework.web.servlet.View;
import org.springframework.web.servlet.ViewResolver;

import java.util.Locale;

/**
 * Simple ViewResolver to provide a JsonView
 *
 * @author Bob McCune
 * @version $Revision$, $Date$
 */
public class JsonViewResolver implements ViewResolver {

	private JsonView	view;

	public JsonViewResolver () {
		view = new JsonView();
	}

	public View resolveViewName (String viewName, Locale locale) throws Exception {
		return view;
	}
}
