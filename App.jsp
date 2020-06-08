<%@ page import = "java.util.*" %><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html 
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
<head>
    <meta http-equiv="Content-Type" content='text/html; charset=UTF-8'/>
    <meta http-equiv="Content-Style-Type" content="text/css"/>
    <link rel="stylesheet" media="screen" type="text/css" title="Preferred" href="number-guess.css"/>
    <title>JSP Number Guess</title>
</head>
<body>

    <h1>JSP Number Guess</h1>

    <div class='content'>
<%
//  Initialize.

    final HttpSession       Sess = request.getSession();
    final boolean           JustStarted = Sess.isNew();
    final Integer           No;
    final ArrayList         Hist;

    if (JustStarted) {

        No = new Integer(new java.util.Random().nextInt(101));
        Hist = new ArrayList();

        Sess.setAttribute("no", No);
        Sess.setAttribute("hist", Hist);

    } else {

        No = (Integer) Sess.getAttribute("no");
        Hist = (ArrayList) Sess.getAttribute("hist");
    }

//  Process the input.

    final String            GuessStr = request.getParameter("guess");
    String                  GuessErrorMsg = null;
    int                     Guess = -1;

    if (!JustStarted) {

        if (GuessStr != null && GuessStr.length() != 0) {

            try {

                Guess = Integer.parseInt(GuessStr);
                if (Guess < 0 || Guess > 100)
                    GuessErrorMsg = "The guess must be in the range 0 to 100 (inclusive). " + 
                        "The number \"" + Guess + "\" is not in that range.";
                else
                    Hist.add(new Integer(Guess));

            } catch (NumberFormatException e) {
                GuessErrorMsg = "The guess \"" + GuessStr + "\" is not a number.";
            }

        } else
            GuessErrorMsg = "The guess should be a number, but is blank.";
    }

//  Produce the dynamic portions of the web page.

    if (Guess != No.intValue()) {
%>
        <div class='guess'>
            <p>A random number between 0 and 100 (inclusive) has been selected.</p>
<%
        if (GuessErrorMsg != null) {
%>
            <div class='bad-field-error-message'><%= GuessErrorMsg %></div>
<%
        }
%>
            <form method='post'>
                <label <%= GuessErrorMsg != null ? "class='bad-field'" : "" %> >Guess the number: 
                    <input type='text' size='6' name='guess' 
                    <%= GuessErrorMsg != null ? "value='" + GuessStr + "'" : "" %> />
                </label>
                <input type='submit' value='Guess'/>
            </form>
        </div>
<%
    } else {

        Sess.invalidate();  //  Destroy this session. We're done.
%>
        <div class='done'>
            <p>Correct! The number was <%= No %>. 
            You guessed it in <%= Hist.size() %> attempts.</p>

            <form method='post'>
                <input type='submit' value='Play Again'/>
            </form>
        </div>
<%
    }

    if (Hist.size() > 0) {
%>
        <div class='history'>
            <table class='history'>
                <thead>
                    <tr>
                        <th>No.</th> <th>Guess</th> <th>Result</th>
                    </tr>
                </thead>
                <tbody>
<%
        for (int Index = Hist.size() - 1; Index >= 0; Index--) {
            final Integer           PrevGuess = (Integer) Hist.get(Index);
            final int               Relationship = PrevGuess.compareTo(No);
            String                  Result = "Correct!";

            if (Relationship < 0)
                Result = "Too Low";
            else if (Relationship > 0)
                Result = "Too High";
%>
                    <tr>
                        <td><%= Index + 1 %></td> <td><%= PrevGuess %></td> <td class='result'><%= Result %></td>
                    </tr>
<%
        }
%>
                </tbody>
            </table>
        </div>
<%
    }
%>
    </div>

</body>
</html>
