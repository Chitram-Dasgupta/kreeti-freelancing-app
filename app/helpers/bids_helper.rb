# frozen_string_literal: true

module BidsHelper
  include ApplicationHelper

  def display_bid_action(label, path, icon_name, style)
    http_method = set_bid_http_method(icon_name, style)
    display_action(label, path, icon_name, style, http_method)
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
end
