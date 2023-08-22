package com.ttmsoft.toaf.exception;

/**
 * 
 * 기  능	: 기본 LOAF 예외처리
 * 파일명	: DefaultFrameworkException.java
 * 패키지	: ttmsoft.toaf.exception
 * 설  명	: 
 * 변경이력	: 
 * 2020.03.03	[sgchoi] - 최초작성 
 * 
 */
public class FrameworkException extends RuntimeException {


	/**	serialVersionUID */
	private static final long	serialVersionUID	= -4712499572703640440L;

	/**
	 * Constructor of DefaultFrameworkException.java class
	 * 
	 * @param t : cause
	 */
	public FrameworkException (Throwable t) {
		super(t);
	}

	/**
	 * Constructor of DefaultFrameworkException.java class
	 * 
	 * @param message : 예외 메시지
	 */
	public FrameworkException (String message) {
		super(message);
	}

	/**
	 * Constructor of DefaultFrameworkException.java class
	 * 
	 * @param message : 예외 메시지
	 * @param t : cause
	 */
	public FrameworkException (String message, Throwable t) {
		super(message, t);
	}

	@Override
	public String toString () {
		return getStackTraceView(this).toString();
	}

	/**
	 * Desc : 예외 trace 문자열을 반환한다.
	 * 
	 * @Method : getStackTraceView
	 * @param t - Throwable
	 * @return errorStack : 예외 스택 String
	 */
	public static StringBuffer getStackTraceView (Throwable t) {
		StringBuffer errorStack = new StringBuffer();

		errorStack.append(t.getClass().getName());
		errorStack.append(":");
		errorStack.append(t.getMessage());
		errorStack.append("\n\n");

		StackTraceElement[] stacks = t.getStackTrace();

		for (int i = 0; i < stacks.length; i++) {
			errorStack.append("\t at ").append(stacks[i]).append("\n");
		}

		Throwable cause = t.getCause();

		if (cause != null) {
			errorStack.append("\n  Caused By : ");
			errorStack.append(getStackTraceView(cause));
		}

		errorStack.append("\n");

		return errorStack;
	}
}
