#include <string>

namespace cx {
namespace ECMAScript {
namespace String {

bool startsWith(std::string a, std::string b) {
	return a.substr(0, b.size()) == b;
}

bool endsWith(std::string a, std::string b) {
	return a.substr(a.size() - b.size(), b.size()) == b;
}

std::vector<std::string> split(std::string str, char splitter) {
	std::vector<std::string> splitted;
	size_t last = 0;
	for (size_t i = 0; i < str.size(); ++i) {
		if (str[i] == splitter) {
			splitted.push_back(str.substr(last, i - last));
			last = i + 1;
		}
	}
	splitted.push_back(str.substr(last));
	return splitted;
}

} // String
} // ECMAScript
} // cx
