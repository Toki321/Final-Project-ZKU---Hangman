var programming_languages = [
    "python",
    "javascript",
    "mongodb"
]

function randomWord() {
    return programming_languages[Math.floor(Math.random() * programming_languages.length)]
}

export { randomWord }