console.log("add to cart")
var flashContent = '<%=j render("shared/flash", :flash => flash ) %>';
CommonScripts.showFlash(flashContent);

<% count = session[:cart] ? session[:cart].length : 0 %>
Reward.updateCartCount('<%=j render "rewards/shopping_cart", :count => count %>');