package com.ttmsoft.toaf.util;

import java.io.File;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;
import java.util.ResourceBundle;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSendException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import com.sun.mail.smtp.SMTPSenderFailedException;
import com.ttmsoft.lms.cmm.properties.MailProperties;
import com.ttmsoft.toaf.object.DataMap;

@Component
public class CommonUtil {
	

	@Autowired
	private  JavaMailSender javaMailSender;
	
	@Autowired
	private MailProperties mailProperties;
	
	/**
	 * 문자열을 Byte 수 만큼 자르고 "..." 을 붙여 잘린 문자열임을 표시
	 *
	 * @param src
	 * @param max
	 * @return
	 */
	public static String cutByteString (String src, int max) {
		String result = "";

		if ((null == src) || "".equals(src)) return result;
		if (max <= 0) return src;

		try {
			char curChar;
			byte[] curBytes;
			int nowsz = 0, strsz = 0;
			for (int i = 0; i < src.length(); i++) {
				curChar = src.charAt(i);

				curBytes = ("" + curChar).getBytes("UTF-8");
				strsz = curBytes.length;

				if (strsz == 3) nowsz += 2;
				else nowsz += strsz;

				if (nowsz > max) break;
				else result += curChar;
			}
			if (src.length() > result.length()) result += "...";
		}
		catch (Exception e) {
			result = src;
		}

		return result;
	}

	/**
	 * 리스트에 담긴 컬럼(단수)의 길이를 btye 단위로 잘라준다.
	 * 
	 * @param list
	 * @param columName
	 * @param length
	 */
	public static void cutTitle (List<DataMap> list, String columName, int length) {
		for (DataMap dataMap : list) {
			dataMap.put(columName, cutByteString(String.valueOf(dataMap.get(columName)), length));
		}
	}

	/**
	 * 다국어 지원 ResourceBundle 객체 생성
	 * 
	 * @param baseName
	 * @param request
	 * @return
	 */
	public static ResourceBundle getResourceBundle (String baseName, HttpServletRequest request) {
		ResourceBundle result = null;

		String tmpStr = request.getHeader("Accept-Language");
		String lang = "en";
		try {
			if (tmpStr != null && tmpStr.length() > 1) {
				lang = tmpStr.substring(0, 2).toLowerCase();
			}	
			java.util.Locale locale = new java.util.Locale(lang, "");
			result = ResourceBundle.getBundle(baseName, locale);
		}
		catch (Exception e) {
			result = ResourceBundle.getBundle(baseName, java.util.Locale.ENGLISH);
		}

		return result;
	}

	/**
	 * 세션 language 얻기 - Locale("ko")
	 * 
	 * @param request
	 * @return
	 */
	public static Locale getLocale (HttpServletRequest request) {
		return new Locale(String.valueOf(request.getSession().getAttribute("sess_lang")));
	}

	/**
	 * 클라이언트 IP 얻기
	 * 
	 * @param req
	 * @return
	 */
	public static String getRemoteAddress (HttpServletRequest req) {
		String ip = req.getHeader("X-FORWARDED-FOR");
		if (ip == null || ip.length() == 0) ip = req.getHeader("Proxy-Client-IP");
		if (ip == null || ip.length() == 0) ip = req.getRemoteAddr();

		return ip;
	}
	
	public static String randomString() {
		Random rnd =new Random();
		StringBuffer buf =new StringBuffer();
		for(int i=0;i<10;i++){
		    // rnd.nextBoolean() 는 랜덤으로 true, false 를 리턴. true일 시 랜덤 한 소문자를, false 일 시 랜덤 한 숫자를 StringBuffer 에 append 한다.
		    if(rnd.nextBoolean()){
		        buf.append((char)((int)(rnd.nextInt(26))+97));
		    }else{
		        buf.append((rnd.nextInt(10)));
		    }
		}
		
		return buf.toString();
	}
	
	/**
	 * 이메일 전송
	 */
	public int doMailSender(DataMap paraMap)throws MailSendException,SMTPSenderFailedException{
		int result = 0;
		String charSet = "UTF-8" ;
	      try {
	         //메일 환경 변수 설정입니다.
	    	 Properties props = new Properties();
	    	  
	    	 props.setProperty("mail.smtp.starttls.enable", "true");
	    	 props.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
		         
	         //mail 수신자 ID, PW 설정
	         props.setProperty("id", mailProperties.getUsername());
	         props.setProperty("pw", mailProperties.getPassword());
	         
	         //메일 프로토콜
	         props.setProperty("mail.transport.protocol", "smtp");
	         
	         //메일 호스트 주소를 설정합니다.
	         props.setProperty("mail.host", mailProperties.getHost());
	         
	         // ID, Password 설정이 필요합니다.
	         props.put("mail.smtp.auth", "true");
	         
	         // port는 465입니다.
	         props.put("mail.smtp.port", mailProperties.getPort());
	         //props.put("mail.smtp.ssl.enable", "true");
	         
	         // id와 pw를 설정하고 session을 생성합니다.
	         Session session = Session.getInstance(props, new Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	               return new PasswordAuthentication(props.getProperty("id"), props.getProperty("pw"));
	            }
	         });

	         // 디버그 모드입니다.
	         //session.setDebug(true);
	         // 메일 메시지를 만들기 위한 클래스를 생성합니다.
	         //String fromId = "rndvoucher@compa.re.kr";
	         String fromId = mailProperties.getUsername();
	         //String fromName = "과학기술일자리진흥원";
	         
	         MimeMessage message = new MimeMessage(session);
	         
	         // 송신자 설정
	         message.setFrom(getAddress(fromId));
	         //message.setFrom(fromId );
	         
	         // 수신자 설정
	         message.setRecipient(Message.RecipientType.TO, new InternetAddress(paraMap.get("user_email").toString()));
	                  
	         // 메일 제목을 설정합니다.
	         message.setSubject(paraMap.getstr("subject"),charSet);

	         // 메일 내용을 설정을 위한 클래스를 설정합니다.
	         message.setContent(new MimeMultipart());
	         // 메일 내용을 위한 Multipart클래스를 받아온다. (위 new MimeMultipart()로 넣은 클래스입니다.)
	         Multipart mp = (Multipart) message.getContent();
	         System.out.println("paraMap:"+paraMap);
	         // html 형식으로 본문을 작성해서 바운더리에 넣습니다.
	         String mailBody = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n" + 
	         		"<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n" + 
	         		"<head>\r\n" + 
	         		"   <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\r\n" + 
	         		"   <title>바우처사업관리시스템</title>\r\n" + 
	         		"   <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\r\n" + 
	         		"  </head>\r\n" + 
	         		"  <body style=\"padding: 0;margin: 0;\">\r\n" + 
	         		"   <!-- OUTERMOST CONTAINER TABLE -->\r\n" + 
	         		"   <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" id=\"bodyTable\">\r\n" + 
	         		"     <tr>\r\n" + 
	         		"      <td>\r\n" + 
	         		"        <!-- 600px - 800px CONTENTS CONTAINER TABLE -->\r\n" + 
	         		"        <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"700\" height=\"700\" style=\"background: rgb(201 201 201)\">\r\n" + 
	         		"         <tr>\r\n" + 
	         		"           <td>\r\n" + 
	         		"            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"700\" height=\"700\">\r\n" + 
	         		"               <tr>\r\n" + 
	         		"                  <td style=\"vertical-align: top;\">\r\n" + 
	         		"                     <table style=\"background: #fff; border-radius: 10px; height:680px; width:680px; margin:10px\">\r\n" + 
	         		"                        <tr>\r\n" + 
	         		"                           <td style=\"vertical-align: top;\">\r\n" + 
	         		"                              <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"width: 100%;\">\r\n" + 
	         		"                                 <tr>\r\n" + 
	         		"                                    <td style='text-align:left;font-family:Noto Sans KR,\"Noto Sans KR\", -apple-system, helvetica, \"Apple SD Gothic Neo\", sans-serif;font-size:18px; color:#000; padding: 20px  ;'>\r\n" + 
	         		"										<p style=\"border-bottom: 1px solid #565656;padding-bottom: 15px;\">"+paraMap.getstr("subject")+"</p>\r\n" + 
	         		"									</td>   \r\n" + 
	         		"                                 </tr>\r\n" + 
	         		"                                 <tr>\r\n" + 
	         		"                                    <td style='text-align:left;font-family:Noto Sans KR,\"Noto Sans KR\", -apple-system, helvetica, \"Apple SD Gothic Neo\", sans-serif;font-size:16px; padding: 0px 20px 40px;'>\r\n" + 
	         		"                                       "+paraMap.getstr("text")+"\r\n" + 
	         		"                                    </td>\r\n" + 
	         		"                                 </tr>\r\n" + 
	         		"                                 <tr>\r\n" + 
	         		"                                    <td style='text-align:center;font-family:\"Noto Sans KR-Regular\",Noto Sans KR,\"Noto Sans KR\", -apple-system, helvetica, \"Apple SD Gothic Neo\", sans-serif;font-size:12px; color:#5c5c5c;    padding: 20px;'>\r\n" + 
	         		"                                       \r\n" + 
	         		"                                       <div style=\" border-radius: 10px; background: #e9e9e9; padding:20px\">\r\n" + 
	         		"                                          <p style=\"margin:0 0 5px\">본 메일은 회신되지 않는 발신전용 메일입니다.</p>\r\n" + 
	         		"                                          <p style=\"margin:0 0 5px\">주식회사 티비즈: 서울특별시 강남구 테헤란로 10길 18, 6층 (역삼동, 하나빌딩)</p>\r\n" + 
	         		"                                          <p style=\"margin:0 0 5px\">\r\n" + 
	         		"                                             <a href=\"http://114.202.2.226:8882\" style=\"text-decoration: none;\">기술이전-거래플랫폼 <strong>SITE</strong> 바로가기</a>\r\n" + 
	         		"                                          </p>\r\n" + 
	         		"                                       </div>   \r\n" + 
	         		"                                    </td>\r\n" + 
	         		"                                 </tr>\r\n" + 
	         		"                              </table>\r\n" + 
	         		"                           </td>\r\n" + 
	         		"                        </tr>\r\n" + 
	         		"                     </table>\r\n" + 
	         		"                  </td>\r\n" + 
	         		"               </tr>\r\n" + 
	         		"            </table>\r\n" + 
	         		"           </td>\r\n" + 
	         		"           <td></td>\r\n" + 
	         		"         </tr>\r\n" + 
	         		"        </table>\r\n" + 
	         		"  \r\n" + 
	         		"      </td>\r\n" + 
	         		"     </tr>\r\n" + 
	         		"   </table>\r\n" + 
	         		"  </body>\r\n" + 
	         		"</html>";
	         
	         mp.addBodyPart(getContents(mailBody));;
	         
	         // 메일을 보냅니다.
	         Transport.send(message);
	         result=1001;//메일전송성공시

	      } catch (Throwable e) {
	         result=2002;//메일전송실패시
	         System.out.println("메일전송오류났어요");
	         //e.printStackTrace();
	         
	         return result;
	      }
	      return result;
	}
	
	
	// 이미지를 로컬로 부터 읽어와서 BodyPart 클래스로 만든다. (바운더리 변환)
	   private BodyPart getImage(String filename, String contextId) throws MessagingException {
	      //파일을 읽어와서 BodyPart 클래스로 받는다.
	      BodyPart mbp = getFileAttachment(filename);
	      if (contextId != null) {
	         // ContextId 설정
	         mbp.setHeader("Content-ID", "<" + contextId + ">");
	      }
	      return mbp;
	   }
	   // 파일을 로컬로 부터 읽어와서 BodyPart 클래스로 만든다. (바운더리 변환)
	   private BodyPart getFileAttachment(String filename) throws MessagingException {
	      // BodyPart 생성
	      BodyPart mbp = new MimeBodyPart();
	      
	      // 파일 읽어서 BodyPart에 설정(바운더리 변환)
	      File file = new File(filename);
	      
	      DataSource source = new FileDataSource(file);
	      mbp.setDataHandler(new DataHandler(source));
	      mbp.setDisposition(Part.ATTACHMENT);
	      mbp.setFileName(file.getName());
	      
	      return mbp;
	   }
	   // 메일의 본문 내용 설정
	   private BodyPart getContents(String html) throws MessagingException {
	      BodyPart mbp = new MimeBodyPart();
	      //setText를 이용할 경우 일반 텍스트 내용으로 설정된다.
	      //mbp.setText(html);
	      //html 형식으로 설정
	      mbp.setContent(html, "text/html; charset=utf-8");
	      return mbp;
	   }
	   
	   //String으로 된 메일 주소를 Address 클래스로 변환
	   private Address getAddress(String address) throws AddressException {
	      return new InternetAddress(address);
	   }
	   
	   //String으로 된 복수의 메일 주소를 콤마(,)의 구분으로 Address array형태로 변환
	   private Address[] getAddresses(String addresses) throws AddressException {
	      String[] array = addresses.split(",");
	      Address[] ret = new Address[array.length];
	      for (int i = 0; i < ret.length; i++) {
	         ret[i] = getAddress(array[i]);
	      }
	      return ret;
	   }
}
