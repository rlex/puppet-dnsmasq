<% if @domain != '' -%>
<%= "dns-rr=#{@domain},#{@type},#{@rdata}\n" -%>
<% end -%>
