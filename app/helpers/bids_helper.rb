# frozen_string_literal: true

module BidsHelper
  def display_bid_action(label, path, icon_name, style)
    http_method = set_bid_http_method(icon_name, style)
    link_to(path,
            { class: "btn btn-#{style} mt-2", method: http_method,
              data: (http_method == :delete ? { confirm: 'Are you sure?' } : {}) }) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end

  def display_bid_document(bid, document_type)
    document = bid.send("bid_#{document_type}_document")
    if document.attached?
      render 'row', label: "#{document_type.to_s.titleize} Document",
                    value: link_to(document.filename, url_for(document), class: 'btn btn-secondary mt-2')
    else
      content_tag(:p, "No #{document_type} document attached.")
    end
  end

  def icon(name)
    content_tag(:i, '', class: "bi bi-#{name}")
  end

  def set_bid_http_method(icon_name, style)
    if icon_name == 'trash' && style == 'danger'
      :delete
    elsif icon_name == 'chat-dots' && style == 'info'
      :post
    end
  end
end
