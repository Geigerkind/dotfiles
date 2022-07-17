from ulauncher.api.client.Extension import Extension
from ulauncher.api.client.EventListener import EventListener
from ulauncher.api.shared.event import \
	KeywordQueryEvent, ItemEnterEvent, PreferencesEvent, PreferencesUpdateEvent
from ulauncher.api.shared.item.ExtensionResultItem import ExtensionResultItem
from ulauncher.api.shared.action.RenderResultListAction import RenderResultListAction
from ulauncher.api.shared.action.HideWindowAction import HideWindowAction
from ulauncher.api.shared.action.ExtensionCustomAction import ExtensionCustomAction
from ulauncher.api.shared.action.DoNothingAction import DoNothingAction
import os
from logic import CommandList, Expression

class CommandRunner(Extension):

	def __init__(self, items_limit = 9):
		super().__init__()
		self.commands = CommandList()
		self.items_limit = items_limit
		self.options = {}

		self.subscribe(KeywordQueryEvent, KeywordQueryListener())
		self.subscribe(ItemEnterEvent, ItemEnterListener())
		self.subscribe(PreferencesEvent, PreferencesListener())
		self.subscribe(PreferencesUpdateEvent, PreferencesUpdateListener())

	def in_terminal(self, keyword):
		return self.options['keyword_terminal'] == keyword

	def update_command_list(self):
		self.commands.names = self.options['commands']

class KeywordQueryListener(EventListener):

	def on_event(self, event, extension):
		query = event.get_argument()
		if not query:
			return DoNothingAction()
		query = Expression(query)

		in_terminal = extension.in_terminal(event.get_keyword())
		commands = extension.commands.search(query.command)
		commands = commands[: extension.items_limit]
		result = []

		for variant in commands:
			expression = Expression(query.data)
			expression.command = variant
			description = f'Run command "{variant}"'

			if in_terminal:
				env = extension.options['terminal'].command
				description = f'Launch "{env}" with command "{variant}"'

			result.append(ExtensionResultItem(
				icon = 'images/icon.svg',
				name = str(expression),
				description = description,
				on_enter = ExtensionCustomAction([expression, in_terminal])
			))

		return RenderResultListAction(result)

class ItemEnterListener(EventListener):

	def on_event(self, event, extension):
		expression, in_terminal = event.get_data()

		expression = expression.wrap(extension.options['shell'])
		if in_terminal:
			expression = expression.wrap(extension.options['terminal'])

		expression.run()

class PreferencesManager(EventListener):

	def save(self, key, value, old_value, extension):
		if key == 'commands':
			output, error = Expression(value).run(text = True).communicate()
			value = output.split('\n') if not error else []

		if key == 'shell' or key == 'terminal':
			value = Expression(os.path.expandvars(value))

		extension.options[key] = value
		if key == 'commands':
			extension.update_command_list()

class PreferencesListener(PreferencesManager):

	def on_event(self, event, extension):
		for key, value in event.preferences.items():
			self.save(key, value, None, extension)

class PreferencesUpdateListener(PreferencesManager):

	def on_event(self, event, extension):
		self.save(event.id, event.new_value, event.old_value, extension)

if __name__ == '__main__':
	CommandRunner().run()