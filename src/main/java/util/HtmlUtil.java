package util;

/**
 * HtmlUtil - Utility class providing basic HTML escaping to mitigate Cross-Site Scripting (XSS).
 */
public final class HtmlUtil {

    private HtmlUtil() {
        // Prevent instantiation
    }

    /**
     * Escapes special HTML characters (&, <, >, ", ') to their respective HTML entity equivalents.
     *
     * @param input the raw string to escape
     * @return the HTML-escaped string, or empty string if input is null
     */
    public static String escape(String input) {
        if (input == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(input.length() + 16);
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '&':
                    sb.append("&amp;");
                    break;
                case '<':
                    sb.append("&lt;");
                    break;
                case '>':
                    sb.append("&gt;");
                    break;
                case '"':
                    sb.append("&quot;");
                    break;
                case '\'':
                    sb.append("&#x27;");
                    break;
                default:
                    sb.append(c);
                    break;
            }
        }
        return sb.toString();
    }
}
