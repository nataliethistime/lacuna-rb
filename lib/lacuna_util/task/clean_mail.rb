# encoding: utf-8

require 'lacuna_util/task'

class CleanMail < LacunaUtil::Task
    def run
        super

        status = Lacuna::Empire.get_status

        if status['empire']['has_new_messages'].to_i == 0
            puts "No messages to delete! You're all clear!"
            return
        end

        # Array of message ids representing messages needing to be trashed.
        to_trash = []

        page = 1
        seen = 0
        tags = ['Parliament', 'Probe']

        # Isolationists are not affected by Fissures.
        tags << 'Fissure' if status['empire']['is_isolationist'].to_i > 0

        while true
            puts "Checking page #{page}"

            inbox = Lacuna::Inbox.view_inbox({
                :tags => tags,
                :page_number => page,
            })

            inbox['messages'].each do |message|
                seen += 1
                to_trash << message['id']
            end

            # Check if this is the last page.
            if inbox['message_count'].to_i == seen
                break
            else
                page += 1
            end
        end

        puts "Trashing #{to_trash.size} messages... hang on tight, kid!"
        Lacuna::Inbox.trash_messages to_trash
    end
end

LacunaUtil.register_task CleanMail
