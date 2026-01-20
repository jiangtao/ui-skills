# UI FE Skills

![UI FE Skills](./public/cover.webp)

UI FE Skills is a small set of **opinionated, evolving constraints** to guide agents when building interfaces.

Every rule comes from things that bored me when using agents to build UI.

## Credits

This project is based on [UI Skills](https://github.com/ibelick/ui-skills) by [ibelick](https://github.com/ibelick). The original work is licensed under the MIT License.

### Original Author

- **ibelick** - [GitHub](https://github.com/ibelick) · [Twitter](https://twitter.com/ibelick)

### Enhancements

This fork (`ui-fe-skills`) extends the original with additional features:

- Mobile responsive design with mobile-first approach
- Accessibility (a11y) following WCAG 2.1 AA guidelines
- Dark/light theme support with system preference detection
- Platform detection for Web and React Native
- Selective installation (`--only` flag)

Learn more about [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)

## CLI

```bash
npx ui-fe-skills init
```

This installs the skill and registers the command in supported tools.

### Selective Installation

Install only to specific tools:

```bash
# Install only to Claude Code
npx ui-fe-skills init --only claude

# Install to multiple tools
npx ui-fe-skills init --only claude,cursor
```

## License

Licensed under the [MIT license](./LICENSE).
