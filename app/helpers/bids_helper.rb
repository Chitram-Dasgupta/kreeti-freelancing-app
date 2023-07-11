# frozen_string_literal: true

module BidsHelper
  def display_document(bid, document_type)
    document = bid.send("bid_#{document_type}_document")
    if document.attached?
      render :row, label: "#{document_type.to_s.titleize} Document",
                   value: link_to(document.filename, url_for(document), class: 'btn btn-secondary mt-2')
    else
      content_tag(:p, "No #{document_type} document attached.")
    end
  end

  def display_bid_actions(bid)
    return unless current_user == bid.user || admin?

    if bid.modifiable?
      display_bid_action('Edit this bid', edit_bid_path(bid), 'pencil', 'warning')
    elsif bid.accepted?
      display_bid_action('Submit project files', edit_bid_path(bid), 'upload', 'info') +
        display_bid_action('Chat', rooms_path(user_id: bid.project.user_id), 'chat-dots', 'primary', method: :post)
    end
  end

  def display_bid_action(label, path, icon_name, style, options = {})
    link_to(path, { class: "btn btn-#{style} mt-2" }.merge(options)) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end

  def icon(name)
    content_tag(:i, '', class: "bi bi-#{name}")
  end
end
