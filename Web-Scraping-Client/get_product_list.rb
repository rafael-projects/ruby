require 'mechanize'
agent = Mechanize.new

page = agent.get('http://localhost:3000')

login_form = page.form


puts page

login_form.field_with(name: 'user[email]').value = 'example@example.com'
login_form.field_with(name: 'user[password]').value = '123456'

product_list_page = agent.submit(login_form)
#Cria um novo arquivo  para pegar todas as paginas de produtos
out_file = File.new('product_list.txt', 'w')
out_file.puts 'Product List:'


loop do
#pega lista de produtos
product_list_page.search('tbody tr').each do |p|
    #extrai as colunas dos produtos, organiza e escreve no arquivo
    f = p.search('td')
    line ="title: #{f[0].text}, "
    line +="brand: #{f[1].text}, "
    line ="description: #{f[2].text}, "
    line ="price: #{f[3].text}"
    out_file.puts line
    end


break unless product_list_page.link_with(text: 'Next >')

product_list_page = product_list_page.link_with(text: 'Next >').click
end

out_file.close