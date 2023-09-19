<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>메일 데모 페이지</title>
<style>
  .data-form .row {
    display: flex;
    margin-bottom: 15px;
  }

  .data-form .row input,textarea{
    margin-left: 15px;
  }
</style>
</head>
<body>
	<h1>메일 데모 페이지</h1>

  <form class="data-form" name="mailForm" method="POST" action="/demo/mail/send" onsubmit="pageScript.submitHandler(this); return false">
    <div class="row">
      송신메일 : <input name="user_email" type="text" placeholder="demo@sample.com"/>
    </div>

    <div class="row">
      제목 : <input name="subject" type="text" placeholder="제목"/>
    </div>
    
    <div class="row">
      내용 : <textarea name="text" rows="5" cols="40" placeholder="내용"></textarea>
    </div>

    <button type="submit">송신</button>
  </form>

  <div class="row" style="margin-top:15px">
    결과 : <input name="sendResult" readonly/>
  </div>

  <script>
    const pageScript = ((window, documnet) => {
      const submitHandler = async (form) => {
        const resultEl = document.querySelector('input[name=sendResult]');
        resultEl.value = "전송중";
        
        let params = {
          user_email: form.user_email.value,
          subject: form.subject.value,
          text: form.text.value,
        };
        

        let response = await fetch("/demo/mail/send", {
          method: 'POST',
          body: JSON.stringify(params),
          headers: {
            "Content-Type": "application/json",
          },
        });

        const result = await response.json();

        if(result.message) {
          resultEl.value = result.message;
        }else {
          resultEl.value = result.status;
        }
        

        return false;
      }

      return {
        submitHandler: submitHandler,
      }
    })(window, document);
  </script>
</body>
</html>