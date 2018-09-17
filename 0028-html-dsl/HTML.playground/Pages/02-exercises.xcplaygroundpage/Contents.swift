/*:
 # An HTML DSL

 ## Exercises

 1.) Our `render` function currently prints an extra space when attributes aren't present: `"<header ></header>"`. Fix the `render` function so that `render(header([])) == "<header></header>"`.
 */
// TODO
/*:
 2.) HTML specifies a number of "[void elements](https://www.w3.org/TR/html5/syntax.html#void-elements)" (elements that have no closing tag). This includes the `img` element in our example. Update the `render` function to omit the closing tag on void elements.
 */
// TODO
/*:
 3.) Our `render` function is currently unsafe: text node content isn't escaped, which means it could be susceptible to cross-site scripting attacks. Ensure that text nodes are properly escaped during rendering.
 */
// TODO
/*:
 4.) Ensure that attribute nodes are properly escaped during rendering.
 */
// TODO
/*:
 5.) Write a function `redacted`, which transforms a `Node` and its children, replacing all non-whitespace characters with a redacted character: `█`.
 */
// TODO
/*:
 6.) Ensure that attribute nodes are properly escaped during rendering.
 */
// TODO
/*:
 7.) Write a function `removingStyles`, which removes all `style` nodes and attributes.
 */
// TODO
/*:
 8.) Write a function `removingScripts`, which removes all `script` nodes and attributes with the `on` prefix (like `onclick`).
 */
// TODO
/*:
 9.) Write a function `plainText`, which transforms HTML into human-readable text, which might be useful for rendering plain-text emails from HTML content.
 */
// TODO
/*:
 10.) One of the most popular way of rendering HTML is to use a templating language (Swift, for example, has [Stencil](https://github.com/stencilproject/Stencil)). What are some of the pros and cons of using a templating language over a DSL.
 */
// TODO
